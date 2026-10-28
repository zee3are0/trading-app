import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_client.dart';
import '../api/health_api.dart';
import '../api/kill_switch_api.dart';
import '../api/strategies_api.dart';
import '../models/health.dart';
import '../models/strategy.dart';
import '../widgets/kill_switch_toggle.dart';
import '../widgets/pl_text.dart';
import '../widgets/status_badge.dart';

class DashboardScreen extends StatefulWidget {
  final ApiClient apiClient;
  const DashboardScreen({super.key, required this.apiClient});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final HealthApi _healthApi;
  late final KillSwitchApi _killSwitchApi;
  late final StrategiesApi _strategiesApi;

  HealthResponse? _health;
  KillSwitchResponse? _killSwitch;
  StrategyPerformanceSummary? _performance;
  Map<String, dynamic>? _systemHealth;
  bool _loading = true;
  bool _killSwitchLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _healthApi = HealthApi(widget.apiClient);
    _killSwitchApi = KillSwitchApi(widget.apiClient);
    _strategiesApi = StrategiesApi(widget.apiClient);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _healthApi.getHealth(),
        _killSwitchApi.getStatus(),
        _strategiesApi.getPerformanceSummary(),
        _healthApi.getSystemHealth(),
      ]);
      if (mounted) {
        setState(() {
          _health = results[0] as HealthResponse;
          _killSwitch = results[1] as KillSwitchResponse;
          _performance = results[2] as StrategyPerformanceSummary;
          _systemHealth = results[3] as Map<String, dynamic>;
          _error = null;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _toggleKillSwitch() async {
    if (_killSwitch == null) return;
    setState(() => _killSwitchLoading = true);
    try {
      final result = _killSwitch!.enabled
          ? await _killSwitchApi.turnOff(reason: 'Disabled from mobile app')
          : await _killSwitchApi.turnOn(reason: 'Enabled from mobile app');
      if (mounted) setState(() => _killSwitch = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _killSwitchLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _health == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _health == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text('Failed to load dashboard'),
            const SizedBox(height: 8),
            FilledButton(onPressed: _refresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (_killSwitch != null)
            KillSwitchToggle(
              enabled: _killSwitch!.enabled,
              loading: _killSwitchLoading,
              onToggle: _toggleKillSwitch,
            ),
          const SizedBox(height: 12),
          if (_performance != null) _buildPortfolioCard(),
          const SizedBox(height: 12),
          if (_performance != null) _buildStrategyCards(),
          const SizedBox(height: 12),
          if (_systemHealth != null) _buildSystemHealthCard(),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard() {
    final p = _performance!.portfolio;
    final currFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Portfolio', style: Theme.of(context).textTheme.titleMedium),
                StatusBadge.fromStatus(_health?.status ?? 'unknown'),
              ],
            ),
            const Divider(),
            _row('Equity', currFmt.format(p.equity)),
            _row('Cash', currFmt.format(p.cash)),
            _row('Positions', '${p.openPositions}'),
            _row('Market Value', currFmt.format(p.marketValue)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _plColumn('Daily P&L', p.dailyPl),
                _plColumn('Unrealized', p.unrealizedPl),
                _plColumn('Cumulative', p.cumulativePl),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyCards() {
    final strategies = _performance!.strategies;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Strategies', style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            ...strategies.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(s.strategyName, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: Text('${s.openPositions}', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 2,
                        child: PlText(value: s.cumulativePl, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealthCard() {
    final services = _systemHealth!.entries.where((e) => e.value is Map).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Health', style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            ...services.map((entry) {
              final data = entry.value as Map<String, dynamic>;
              final ok = data['ok'] == true;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      ok ? Icons.check_circle : Icons.error,
                      size: 16,
                      color: ok ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(entry.key.replaceAll('_', ' ')),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _plColumn(String label, double value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        PlText(value: value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
