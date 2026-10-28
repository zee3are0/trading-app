import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../api/strategies_api.dart';
import '../models/strategy.dart';
import '../widgets/status_badge.dart';

class StrategiesScreen extends StatefulWidget {
  final ApiClient apiClient;
  const StrategiesScreen({super.key, required this.apiClient});

  @override
  State<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends State<StrategiesScreen> {
  late final StrategiesApi _api;
  List<StrategyBundle>? _strategies;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api = StrategiesApi(widget.apiClient);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final strategies = await _api.listStrategies();
      if (mounted) setState(() { _strategies = strategies; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _strategies == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_strategies == null || _strategies!.isEmpty) {
      return const Center(child: Text('No strategies'));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: _strategies!.length,
        itemBuilder: (context, index) => _StrategyCard(
          bundle: _strategies![index],
          onTap: () => _showStrategyDetail(context, _strategies![index]),
        ),
      ),
    );
  }

  void _showStrategyDetail(BuildContext context, StrategyBundle bundle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => _StrategyDetailSheet(
          bundle: bundle,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final StrategyBundle bundle;
  final VoidCallback onTap;
  const _StrategyCard({required this.bundle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = bundle.strategy;
    final shared = bundle.active.shared;
    final enabled = shared['enabled'] as bool? ?? s.enabled;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          enabled ? Icons.play_circle : Icons.pause_circle,
          color: enabled ? Colors.green : Colors.grey,
        ),
        title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${s.strategyType} | ${s.executionMode}',
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(label: enabled ? 'ON' : 'OFF', color: enabled ? Colors.green : Colors.grey),
            if (bundle.draft != null) ...[
              const SizedBox(width: 6),
              StatusBadge(label: 'DRAFT', color: Colors.blue),
            ],
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

class _StrategyDetailSheet extends StatelessWidget {
  final StrategyBundle bundle;
  final ScrollController scrollController;
  const _StrategyDetailSheet({required this.bundle, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final s = bundle.strategy;
    final active = bundle.active;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 32, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(s.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          if (s.description != null)
            Text(s.description!, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          _sectionTitle('Active Config (v${active.version})'),
          _configTable(active.shared, 'Shared'),
          const SizedBox(height: 8),
          _configTable(active.strategyConfig, 'Strategy Config'),
          if (bundle.draft != null) ...[
            const SizedBox(height: 16),
            _sectionTitle('Draft (v${bundle.draft!.version})'),
            _configTable(bundle.draft!.shared, 'Shared'),
            const SizedBox(height: 8),
            _configTable(bundle.draft!.strategyConfig, 'Strategy Config'),
          ],
          const SizedBox(height: 16),
          _sectionTitle('Versions'),
          ...bundle.versions.map((v) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('v${v.version} (${v.status})'),
                subtitle: Text(v.publishedAt ?? v.createdAt ?? ''),
                trailing: v.isActive ? StatusBadge.ok('ACTIVE') : null,
              )),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _configTable(Map<String, dynamic> config, String label) {
    if (config.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        ...config.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(e.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Text(
                      '${e.value}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
