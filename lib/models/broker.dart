class BrokerAccountSummary {
  final String status;
  final String? accountNumber;
  final String? currency;
  final double equity;
  final double lastEquity;
  final double cash;
  final double buyingPower;
  final double portfolioValue;
  final double longMarketValue;
  final double shortMarketValue;
  final double initialMargin;
  final double maintenanceMargin;
  final int daytradeCount;
  final bool patternDayTrader;
  final double unrealizedIntradayPl;

  BrokerAccountSummary({
    required this.status,
    this.accountNumber,
    this.currency,
    required this.equity,
    required this.lastEquity,
    required this.cash,
    required this.buyingPower,
    required this.portfolioValue,
    required this.longMarketValue,
    required this.shortMarketValue,
    required this.initialMargin,
    required this.maintenanceMargin,
    required this.daytradeCount,
    required this.patternDayTrader,
    required this.unrealizedIntradayPl,
  });

  factory BrokerAccountSummary.fromJson(Map<String, dynamic> json) => BrokerAccountSummary(
        status: json['status'] as String? ?? 'unknown',
        accountNumber: json['account_number'] as String?,
        currency: json['currency'] as String?,
        equity: (json['equity'] as num?)?.toDouble() ?? 0,
        lastEquity: (json['last_equity'] as num?)?.toDouble() ?? 0,
        cash: (json['cash'] as num?)?.toDouble() ?? 0,
        buyingPower: (json['buying_power'] as num?)?.toDouble() ?? 0,
        portfolioValue: (json['portfolio_value'] as num?)?.toDouble() ?? 0,
        longMarketValue: (json['long_market_value'] as num?)?.toDouble() ?? 0,
        shortMarketValue: (json['short_market_value'] as num?)?.toDouble() ?? 0,
        initialMargin: (json['initial_margin'] as num?)?.toDouble() ?? 0,
        maintenanceMargin: (json['maintenance_margin'] as num?)?.toDouble() ?? 0,
        daytradeCount: (json['daytrade_count'] as num?)?.toInt() ?? 0,
        patternDayTrader: json['pattern_day_trader'] as bool? ?? false,
        unrealizedIntradayPl: (json['unrealized_intraday_pl'] as num?)?.toDouble() ?? 0,
      );
}

class BrokerPosition {
  final String? strategyName;
  final String symbol;
  final String side;
  final double qty;
  final double marketValue;
  final double avgEntryPrice;
  final double currentPrice;
  final double unrealizedPl;
  final double unrealizedPlpc;
  final double unrealizedIntradayPl;
  final double unrealizedIntradayPlpc;
  final double changeToday;
  final String? assetClass;
  final String? exchange;
  final String? broker;
  final String? brokerEnvironment;
  final String? openedAt;
  final String? status;

  BrokerPosition({
    this.strategyName,
    required this.symbol,
    required this.side,
    required this.qty,
    required this.marketValue,
    required this.avgEntryPrice,
    required this.currentPrice,
    required this.unrealizedPl,
    required this.unrealizedPlpc,
    required this.unrealizedIntradayPl,
    required this.unrealizedIntradayPlpc,
    required this.changeToday,
    this.assetClass,
    this.exchange,
    this.broker,
    this.brokerEnvironment,
    this.openedAt,
    this.status,
  });

  factory BrokerPosition.fromJson(Map<String, dynamic> json) => BrokerPosition(
        strategyName: json['strategy_name'] as String?,
        symbol: json['symbol'] as String? ?? '',
        side: json['side'] as String? ?? '',
        qty: (json['qty'] as num?)?.toDouble() ?? 0,
        marketValue: (json['market_value'] as num?)?.toDouble() ?? 0,
        avgEntryPrice: (json['avg_entry_price'] as num?)?.toDouble() ?? 0,
        currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0,
        unrealizedPl: (json['unrealized_pl'] as num?)?.toDouble() ?? 0,
        unrealizedPlpc: (json['unrealized_plpc'] as num?)?.toDouble() ?? 0,
        unrealizedIntradayPl: (json['unrealized_intraday_pl'] as num?)?.toDouble() ?? 0,
        unrealizedIntradayPlpc: (json['unrealized_intraday_plpc'] as num?)?.toDouble() ?? 0,
        changeToday: (json['change_today'] as num?)?.toDouble() ?? 0,
        assetClass: json['asset_class'] as String?,
        exchange: json['exchange'] as String?,
        broker: json['broker'] as String?,
        brokerEnvironment: json['broker_environment'] as String?,
        openedAt: json['opened_at'] as String?,
        status: json['status'] as String?,
      );
}

class BrokerAlpacaSummary {
  final String broker;
  final BrokerAccountSummary account;
  final List<BrokerPosition> positions;
  final int positionCount;
  final double totalUnrealizedPl;
  final double totalMarketValue;

  BrokerAlpacaSummary({
    required this.broker,
    required this.account,
    required this.positions,
    required this.positionCount,
    required this.totalUnrealizedPl,
    required this.totalMarketValue,
  });

  factory BrokerAlpacaSummary.fromJson(Map<String, dynamic> json) {
    final totals = json['totals'] as Map<String, dynamic>? ?? {};
    return BrokerAlpacaSummary(
      broker: json['broker'] as String? ?? '',
      account: BrokerAccountSummary.fromJson(json['account'] as Map<String, dynamic>? ?? {}),
      positions: (json['positions'] as List<dynamic>?)
              ?.map((e) => BrokerPosition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      positionCount: (totals['position_count'] as num?)?.toInt() ?? 0,
      totalUnrealizedPl: (totals['total_unrealized_pl'] as num?)?.toDouble() ?? 0,
      totalMarketValue: (totals['total_market_value'] as num?)?.toDouble() ?? 0,
    );
  }
}

class BrokerStatusEntry {
  final String broker;
  final bool connected;
  final String? environment;
  final String? detail;

  BrokerStatusEntry({
    required this.broker,
    required this.connected,
    this.environment,
    this.detail,
  });

  factory BrokerStatusEntry.fromJson(Map<String, dynamic> json) => BrokerStatusEntry(
        broker: json['broker'] as String? ?? '',
        connected: json['connected'] as bool? ?? false,
        environment: json['environment'] as String?,
        detail: json['detail'] as String?,
      );
}

class IBKRAccountSummary {
  final double netLiquidation;
  final double totalCash;
  final double buyingPower;
  final double grossPositionValue;
  final double unrealizedPnl;
  final double realizedPnl;

  IBKRAccountSummary({
    required this.netLiquidation,
    required this.totalCash,
    required this.buyingPower,
    required this.grossPositionValue,
    required this.unrealizedPnl,
    required this.realizedPnl,
  });

  factory IBKRAccountSummary.fromJson(Map<String, dynamic> json) => IBKRAccountSummary(
        netLiquidation: (json['net_liquidation'] as num?)?.toDouble() ?? 0,
        totalCash: (json['total_cash'] as num?)?.toDouble() ?? 0,
        buyingPower: (json['buying_power'] as num?)?.toDouble() ?? 0,
        grossPositionValue: (json['gross_position_value'] as num?)?.toDouble() ?? 0,
        unrealizedPnl: (json['unrealized_pnl'] as num?)?.toDouble() ?? 0,
        realizedPnl: (json['realized_pnl'] as num?)?.toDouble() ?? 0,
      );
}

class IBKRPosition {
  final String symbol;
  final double qty;
  final double marketPrice;
  final double marketValue;
  final double averageCost;
  final double unrealizedPnl;
  final double realizedPnl;
  final String? primaryExchange;

  IBKRPosition({
    required this.symbol,
    required this.qty,
    required this.marketPrice,
    required this.marketValue,
    required this.averageCost,
    required this.unrealizedPnl,
    required this.realizedPnl,
    this.primaryExchange,
  });

  factory IBKRPosition.fromJson(Map<String, dynamic> json) => IBKRPosition(
        symbol: json['symbol'] as String? ?? '',
        qty: (json['qty'] as num?)?.toDouble() ?? 0,
        marketPrice: (json['market_price'] as num?)?.toDouble() ?? 0,
        marketValue: (json['market_value'] as num?)?.toDouble() ?? 0,
        averageCost: (json['average_cost'] as num?)?.toDouble() ?? 0,
        unrealizedPnl: (json['unrealized_pnl'] as num?)?.toDouble() ?? 0,
        realizedPnl: (json['realized_pnl'] as num?)?.toDouble() ?? 0,
        primaryExchange: json['primary_exchange'] as String?,
      );
}

class IBKRSummary {
  final String broker;
  final String environment;
  final IBKRAccountSummary account;
  final List<IBKRPosition> positions;
  final int positionCount;

  IBKRSummary({
    required this.broker,
    required this.environment,
    required this.account,
    required this.positions,
    required this.positionCount,
  });

  factory IBKRSummary.fromJson(Map<String, dynamic> json) => IBKRSummary(
        broker: json['broker'] as String? ?? '',
        environment: json['environment'] as String? ?? '',
        account: IBKRAccountSummary.fromJson(json['account'] as Map<String, dynamic>? ?? {}),
        positions: (json['positions'] as List<dynamic>?)
                ?.map((e) => IBKRPosition.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        positionCount: (json['position_count'] as num?)?.toInt() ?? 0,
      );
}
