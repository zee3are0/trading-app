import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_client.dart';
import '../api/broker_api.dart';
import '../models/broker.dart';
import '../widgets/pl_text.dart';
import '../widgets/status_badge.dart';

class BrokerScreen extends StatefulWidget {
  final ApiClient apiClient;
  const BrokerScreen({super.key, required this.apiClient});

  @override
  State<BrokerScreen> createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> with SingleTickerProviderStateMixin {
  late final BrokerApi _api;
  late final TabController _tabController;

  BrokerAlpacaSummary? _alpaca;
  IBKRSummary? _ibkr;
  List<BrokerStatusEntry>? _status;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api = BrokerApi(widget.apiClient);
    _tabController = TabController(length: 2, vsync: this);
    _refresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _api.getAlpacaSummary(),
        _api.getIbkrSummary().catchError((_) => IBKRSummary(
              broker: 'ibkr',
              environment: '',
              account: IBKRAccountSummary(
                netLiquidation: 0, totalCash: 0, buyingPower: 0,
                grossPositionValue: 0, unrealizedPnl: 0, realizedPnl: 0,
              ),
              positions: [],
              positionCount: 0,
            )),
        _api.getStatus(),
      ]);
      if (mounted) {
        setState(() {
          _alpaca = results[0] as BrokerAlpacaSummary;
          _ibkr = results[1] as IBKRSummary;
          _status = results[2] as List<BrokerStatusEntry>;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _alpaca == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          if (_status != null) _buildBrokerStatusBar(),
          TabBar(controller: _tabController, tabs: const [
            Tab(text: 'Alpaca'),
            Tab(text: 'IBKR'),
          ]),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              _buildAlpacaTab(),
              _buildIbkrTab(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBrokerStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _status!.map((s) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                s.connected ? Icons.link : Icons.link_off,
                size: 14,
                color: s.connected ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(s.broker, style: const TextStyle(fontSize: 12)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildAlpacaTab() {
    if (_alpaca == null) return const Center(child: Text('No data'));
    final a = _alpaca!;
    final currFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Account', style: Theme.of(context).textTheme.titleMedium),
                    StatusBadge.fromStatus(a.account.status),
                  ],
                ),
                const Divider(),
                _row('Equity', currFmt.format(a.account.equity)),
                _row('Cash', currFmt.format(a.account.cash)),
                _row('Buying Power', currFmt.format(a.account.buyingPower)),
                _row('Positions', '${a.positionCount}'),
                _row('Market Value', currFmt.format(a.totalMarketValue)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Unrealized P&L'),
                    PlText(value: a.totalUnrealizedPl),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (a.positions.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Positions (${a.positions.length})', style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  ...a.positions.map(_buildPositionTile),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIbkrTab() {
    if (_ibkr == null || _ibkr!.environment.isEmpty) {
      return const Center(child: Text('IBKR not connected'));
    }
    final i = _ibkr!;
    final currFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IBKR Account (${i.environment})', style: Theme.of(context).textTheme.titleMedium),
                const Divider(),
                _row('Net Liquidation', currFmt.format(i.account.netLiquidation)),
                _row('Cash', currFmt.format(i.account.totalCash)),
                _row('Buying Power', currFmt.format(i.account.buyingPower)),
                _row('Positions', '${i.positionCount}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Unrealized P&L'),
                    PlText(value: i.account.unrealizedPnl),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (i.positions.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Positions (${i.positions.length})', style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  ...i.positions.map((p) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(p.symbol, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${p.qty} @ ${currFmt.format(p.averageCost)}'),
                        trailing: PlText(value: p.unrealizedPnl),
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPositionTile(BrokerPosition p) {
    final currFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(p.symbol, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          if (p.strategyName != null)
            Text(p.strategyName!, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
      subtitle: Text('${p.qty} ${p.side} @ ${currFmt.format(p.avgEntryPrice)} | now ${currFmt.format(p.currentPrice)}'),
      trailing: PlText(value: p.unrealizedPl, style: const TextStyle(fontSize: 13)),
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
}
