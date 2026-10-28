import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/events_api.dart';
import '../models/decision.dart';
import '../widgets/status_badge.dart';

class DecisionsScreen extends StatefulWidget {
  final ApiClient apiClient;
  const DecisionsScreen({super.key, required this.apiClient});

  @override
  State<DecisionsScreen> createState() => _DecisionsScreenState();
}

class _DecisionsScreenState extends State<DecisionsScreen> {
  late final EventsApi _api;
  List<Decision>? _decisions;
  bool _loading = true;
  String? _filterStrategy;

  @override
  void initState() {
    super.initState();
    _api = EventsApi(widget.apiClient);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final decisions = await _api.getLiveDecisions();
      if (mounted) setState(() { _decisions = decisions; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Decision> get _filteredDecisions {
    if (_decisions == null) return [];
    if (_filterStrategy == null) return _decisions!;
    return _decisions!.where((d) => d.strategy == _filterStrategy).toList();
  }

  Set<String> get _strategies {
    if (_decisions == null) return {};
    return _decisions!.map((d) => d.strategy).toSet();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _decisions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          if (_strategies.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _filterStrategy == null,
                    onSelected: (_) => setState(() => _filterStrategy = null),
                  ),
                  const SizedBox(width: 6),
                  ..._strategies.map((s) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(s),
                          selected: _filterStrategy == s,
                          onSelected: (_) => setState(() => _filterStrategy = s),
                        ),
                      )),
                ],
              ),
            ),
          Expanded(
            child: _filteredDecisions.isEmpty
                ? const Center(child: Text('No decisions'))
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _filteredDecisions.length,
                    itemBuilder: (context, index) => _DecisionTile(decision: _filteredDecisions[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DecisionTile extends StatelessWidget {
  final Decision decision;
  const _DecisionTile({required this.decision});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmitted = decision.orderSubmitted;
    final isBlocked = decision.decisionStatus == 'blocked';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          isSubmitted
              ? Icons.check_circle
              : isBlocked
                  ? Icons.block
                  : Icons.pending,
          color: isSubmitted
              ? Colors.green
              : isBlocked
                  ? Colors.orange
                  : theme.colorScheme.outline,
          size: 20,
        ),
        title: Row(
          children: [
            Text(decision.symbol, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            StatusBadge(
              label: decision.decisionStatus,
              color: isSubmitted ? Colors.green : isBlocked ? Colors.orange : null,
            ),
          ],
        ),
        subtitle: Text(
          '${decision.strategy} | ${decision.finalSignal} | ${_timeAgo(decision.createdAt)}',
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Model', '${decision.model} (${decision.modelSignal})'),
                _detailRow('Reason', '${decision.reasonCode}: ${decision.reasonDetail}'),
                _detailRow('Broker', '${decision.broker} (${decision.brokerEnvironment})'),
                if (decision.dryRun) _detailRow('Mode', 'DRY RUN'),
                if (decision.killSwitchEnabled) _detailRow('Kill Switch', 'ACTIVE'),
                if (decision.proposedOrderJson != null)
                  _detailRow('Order', _formatOrder(decision.proposedOrderJson!)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  String _formatOrder(Map<String, dynamic> order) {
    final side = order['side'] ?? '';
    final notional = order['notional'];
    final qty = order['qty'];
    if (notional != null) return '$side \$$notional';
    if (qty != null) return '$side $qty shares';
    return side.toString();
  }

  String _timeAgo(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().toUtc().difference(dt);
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return iso;
    }
  }
}
