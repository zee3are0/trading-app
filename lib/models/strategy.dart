class StrategyDefinition {
  final String strategyId;
  final String name;
  final String strategyType;
  final bool enabled;
  final String executionMode;
  final bool supportsConfigDrafts;
  final bool supportsPreview;
  final List<String> supportsProfiles;
  final bool supportsUniverses;
  final String? description;

  StrategyDefinition({
    required this.strategyId,
    required this.name,
    required this.strategyType,
    required this.enabled,
    required this.executionMode,
    required this.supportsConfigDrafts,
    required this.supportsPreview,
    required this.supportsProfiles,
    required this.supportsUniverses,
    this.description,
  });

  factory StrategyDefinition.fromJson(Map<String, dynamic> json) => StrategyDefinition(
        strategyId: json['strategy_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        strategyType: json['strategy_type'] as String? ?? '',
        enabled: json['enabled'] as bool? ?? false,
        executionMode: json['execution_mode'] as String? ?? '',
        supportsConfigDrafts: json['supports_config_drafts'] as bool? ?? false,
        supportsPreview: json['supports_preview'] as bool? ?? false,
        supportsProfiles: (json['supports_profiles'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        supportsUniverses: json['supports_universes'] as bool? ?? false,
        description: json['description'] as String?,
      );
}

class StrategyConfigEnvelope {
  final String strategyId;
  final String strategyType;
  final int version;
  final String status;
  final bool isActive;
  final String? createdAt;
  final String? createdBy;
  final String? publishedAt;
  final String? publishedBy;
  final String? changeSummary;
  final Map<String, dynamic> shared;
  final Map<String, dynamic> strategyConfig;

  StrategyConfigEnvelope({
    required this.strategyId,
    required this.strategyType,
    required this.version,
    required this.status,
    required this.isActive,
    this.createdAt,
    this.createdBy,
    this.publishedAt,
    this.publishedBy,
    this.changeSummary,
    required this.shared,
    required this.strategyConfig,
  });

  factory StrategyConfigEnvelope.fromJson(Map<String, dynamic> json) => StrategyConfigEnvelope(
        strategyId: json['strategy_id'] as String? ?? '',
        strategyType: json['strategy_type'] as String? ?? '',
        version: (json['version'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '',
        isActive: json['is_active'] as bool? ?? false,
        createdAt: json['created_at'] as String?,
        createdBy: json['created_by'] as String?,
        publishedAt: json['published_at'] as String?,
        publishedBy: json['published_by'] as String?,
        changeSummary: json['change_summary'] as String?,
        shared: json['shared'] as Map<String, dynamic>? ?? {},
        strategyConfig: json['strategy_config'] as Map<String, dynamic>? ?? {},
      );
}

class StrategyBundle {
  final StrategyDefinition strategy;
  final StrategyConfigEnvelope active;
  final StrategyConfigEnvelope? draft;
  final List<StrategyConfigEnvelope> versions;

  StrategyBundle({
    required this.strategy,
    required this.active,
    this.draft,
    required this.versions,
  });

  factory StrategyBundle.fromJson(Map<String, dynamic> json) => StrategyBundle(
        strategy: StrategyDefinition.fromJson(json['strategy'] as Map<String, dynamic>? ?? {}),
        active: StrategyConfigEnvelope.fromJson(json['active'] as Map<String, dynamic>? ?? {}),
        draft: json['draft'] != null
            ? StrategyConfigEnvelope.fromJson(json['draft'] as Map<String, dynamic>)
            : null,
        versions: (json['versions'] as List<dynamic>?)
                ?.map((e) => StrategyConfigEnvelope.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class StrategyPerformanceRow {
  final String strategyName;
  final int openPositions;
  final double marketValue;
  final double dailyPl;
  final double unrealizedPl;
  final double realizedPl;
  final double cumulativePl;
  final double cashBalance;
  final double lastEffectiveEquity;
  final String? lastReconciledAt;

  StrategyPerformanceRow({
    required this.strategyName,
    required this.openPositions,
    required this.marketValue,
    required this.dailyPl,
    required this.unrealizedPl,
    required this.realizedPl,
    required this.cumulativePl,
    required this.cashBalance,
    required this.lastEffectiveEquity,
    this.lastReconciledAt,
  });

  factory StrategyPerformanceRow.fromJson(Map<String, dynamic> json) => StrategyPerformanceRow(
        strategyName: json['strategy_name'] as String? ?? '',
        openPositions: (json['open_positions'] as num?)?.toInt() ?? 0,
        marketValue: (json['market_value'] as num?)?.toDouble() ?? 0,
        dailyPl: (json['daily_pl'] as num?)?.toDouble() ?? 0,
        unrealizedPl: (json['unrealized_pl'] as num?)?.toDouble() ?? 0,
        realizedPl: (json['realized_pl'] as num?)?.toDouble() ?? 0,
        cumulativePl: (json['cumulative_pl'] as num?)?.toDouble() ?? 0,
        cashBalance: (json['cash_balance'] as num?)?.toDouble() ?? 0,
        lastEffectiveEquity: (json['last_effective_equity'] as num?)?.toDouble() ?? 0,
        lastReconciledAt: json['last_reconciled_at'] as String?,
      );
}

class StrategyPerformanceSummary {
  final String? asOf;
  final PortfolioSummary portfolio;
  final List<StrategyPerformanceRow> strategies;
  final List<dynamic>? positions;
  final String? source;

  StrategyPerformanceSummary({
    this.asOf,
    required this.portfolio,
    required this.strategies,
    this.positions,
    this.source,
  });

  factory StrategyPerformanceSummary.fromJson(Map<String, dynamic> json) =>
      StrategyPerformanceSummary(
        asOf: json['as_of'] as String?,
        portfolio: PortfolioSummary.fromJson(json['portfolio'] as Map<String, dynamic>? ?? {}),
        strategies: (json['strategies'] as List<dynamic>?)
                ?.map((e) => StrategyPerformanceRow.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        positions: json['positions'] as List<dynamic>?,
        source: json['source'] as String?,
      );
}

class PortfolioSummary {
  final double equity;
  final double cash;
  final double buyingPower;
  final int openPositions;
  final double marketValue;
  final double dailyPl;
  final double unrealizedPl;
  final double realizedPl;
  final double cumulativePl;

  PortfolioSummary({
    required this.equity,
    required this.cash,
    required this.buyingPower,
    required this.openPositions,
    required this.marketValue,
    required this.dailyPl,
    required this.unrealizedPl,
    required this.realizedPl,
    required this.cumulativePl,
  });

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) => PortfolioSummary(
        equity: (json['equity'] as num?)?.toDouble() ?? 0,
        cash: (json['cash'] as num?)?.toDouble() ?? 0,
        buyingPower: (json['buying_power'] as num?)?.toDouble() ?? 0,
        openPositions: (json['open_positions'] as num?)?.toInt() ?? 0,
        marketValue: (json['market_value'] as num?)?.toDouble() ?? 0,
        dailyPl: (json['daily_pl'] as num?)?.toDouble() ?? 0,
        unrealizedPl: (json['unrealized_pl'] as num?)?.toDouble() ?? 0,
        realizedPl: (json['realized_pl'] as num?)?.toDouble() ?? 0,
        cumulativePl: (json['cumulative_pl'] as num?)?.toDouble() ?? 0,
      );
}
