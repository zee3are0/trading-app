import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/recommendations_api.dart';
import '../models/recommendation.dart';
import '../widgets/status_badge.dart';

class RecommendationsScreen extends StatefulWidget {
  final ApiClient apiClient;
  const RecommendationsScreen({super.key, required this.apiClient});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late final RecommendationsApi _api;
  List<Recommendation>? _recommendations;
  bool _loading = true;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _api = RecommendationsApi(widget.apiClient);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final recs = await _api.list(status: _statusFilter);
      if (mounted) setState(() { _recommendations = recs; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['all', 'pending_review', 'approved', 'rejected'].map((s) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(s == 'pending_review' ? 'pending' : s),
                      selected: _statusFilter == s,
                      onSelected: (_) {
                        setState(() => _statusFilter = s);
                        _refresh();
                      },
                    ),
                  )).toList(),
            ),
          ),
          Expanded(
            child: _loading && _recommendations == null
                ? const Center(child: CircularProgressIndicator())
                : _recommendations == null || _recommendations!.isEmpty
                    ? const Center(child: Text('No recommendations'))
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _recommendations!.length,
                        itemBuilder: (context, index) => _RecommendationCard(
                          recommendation: _recommendations![index],
                          api: _api,
                          onActionComplete: _refresh,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatefulWidget {
  final Recommendation recommendation;
  final RecommendationsApi api;
  final VoidCallback onActionComplete;

  const _RecommendationCard({
    required this.recommendation,
    required this.api,
    required this.onActionComplete,
  });

  @override
  State<_RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<_RecommendationCard> {
  bool _acting = false;

  Future<void> _approve() async {
    setState(() => _acting = true);
    try {
      await widget.api.approve(widget.recommendation.id);
      widget.onActionComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Approve failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _reject() async {
    final controller = TextEditingController();
    final notes = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Recommendation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Reason'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (notes == null || notes.isEmpty) return;

    setState(() => _acting = true);
    try {
      await widget.api.reject(widget.recommendation.id, operatorNotes: notes);
      widget.onActionComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reject failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recommendation;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(r.symbol, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                StatusBadge.fromStatus(r.status),
                const Spacer(),
                Text(r.recommendationType, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 6),
            Text(r.summary, style: const TextStyle(fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              '${r.strategyName} | ${r.researchDepth} | ${r.llmModel}',
              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
            ),
            if (r.confidence != null)
              Text(
                'Confidence: ${(r.confidence! * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
              ),
            if (r.isPending) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_acting)
                    const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  else ...[
                    OutlinedButton(onPressed: _reject, child: const Text('Reject')),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: _approve, child: const Text('Approve')),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
