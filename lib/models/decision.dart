class Decision {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String symbol;
  final String strategy;
  final String riskBucket;
  final String model;
  final String modelSignal;
  final String finalSignal;
  final String broker;
  final String brokerEnvironment;
  final String decisionStatus;
  final String reasonCode;
  final String reasonDetail;
  final bool terminal;
  final bool overrideApplied;
  final bool killSwitchEnabled;
  final bool cooldownActive;
  final bool approved;
  final bool dryRun;
  final bool orderSubmitted;
  final bool cooldownBlocked;
  final String intentKey;
  final Map<String, dynamic>? proposedOrderJson;
  final Map<String, dynamic>? executedOrderJson;
  final Map<String, dynamic>? signalContextJson;
  final Map<String, dynamic> metadataJson;
  final List<String> eventTypesJson;

  Decision({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.symbol,
    required this.strategy,
    required this.riskBucket,
    required this.model,
    required this.modelSignal,
    required this.finalSignal,
    required this.broker,
    required this.brokerEnvironment,
    required this.decisionStatus,
    required this.reasonCode,
    required this.reasonDetail,
    required this.terminal,
    required this.overrideApplied,
    required this.killSwitchEnabled,
    required this.cooldownActive,
    required this.approved,
    required this.dryRun,
    required this.orderSubmitted,
    required this.cooldownBlocked,
    required this.intentKey,
    this.proposedOrderJson,
    this.executedOrderJson,
    this.signalContextJson,
    required this.metadataJson,
    required this.eventTypesJson,
  });

  factory Decision.fromJson(Map<String, dynamic> json) => Decision(
        id: json['id'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
        updatedAt: json['updated_at'] as String? ?? '',
        symbol: json['symbol'] as String? ?? '',
        strategy: json['strategy'] as String? ?? '',
        riskBucket: json['risk_bucket'] as String? ?? '',
        model: json['model'] as String? ?? '',
        modelSignal: json['model_signal'] as String? ?? '',
        finalSignal: json['final_signal'] as String? ?? '',
        broker: json['broker'] as String? ?? '',
        brokerEnvironment: json['broker_environment'] as String? ?? '',
        decisionStatus: json['decision_status'] as String? ?? '',
        reasonCode: json['reason_code'] as String? ?? '',
        reasonDetail: json['reason_detail'] as String? ?? '',
        terminal: json['terminal'] as bool? ?? false,
        overrideApplied: json['override_applied'] as bool? ?? false,
        killSwitchEnabled: json['kill_switch_enabled'] as bool? ?? false,
        cooldownActive: json['cooldown_active'] as bool? ?? false,
        approved: json['approved'] as bool? ?? false,
        dryRun: json['dry_run'] as bool? ?? true,
        orderSubmitted: json['order_submitted'] as bool? ?? false,
        cooldownBlocked: json['cooldown_blocked'] as bool? ?? false,
        intentKey: json['intent_key'] as String? ?? '',
        proposedOrderJson: json['proposed_order_json'] as Map<String, dynamic>?,
        executedOrderJson: json['executed_order_json'] as Map<String, dynamic>?,
        signalContextJson: json['signal_context_json'] as Map<String, dynamic>?,
        metadataJson: json['metadata_json'] as Map<String, dynamic>? ?? {},
        eventTypesJson: (json['event_types_json'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );
}

class RecentEvent {
  final String id;
  final String createdAt;
  final String eventType;
  final String decisionId;
  final String symbol;
  final String strategy;
  final String broker;
  final String brokerEnvironment;
  final Map<String, dynamic> payloadJson;
  final String deliveryState;

  RecentEvent({
    required this.id,
    required this.createdAt,
    required this.eventType,
    required this.decisionId,
    required this.symbol,
    required this.strategy,
    required this.broker,
    required this.brokerEnvironment,
    required this.payloadJson,
    required this.deliveryState,
  });

  factory RecentEvent.fromJson(Map<String, dynamic> json) => RecentEvent(
        id: json['id'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
        eventType: json['event_type'] as String? ?? '',
        decisionId: json['decision_id'] as String? ?? '',
        symbol: json['symbol'] as String? ?? '',
        strategy: json['strategy'] as String? ?? '',
        broker: json['broker'] as String? ?? '',
        brokerEnvironment: json['broker_environment'] as String? ?? '',
        payloadJson: json['payload_json'] as Map<String, dynamic>? ?? {},
        deliveryState: json['delivery_state'] as String? ?? '',
      );
}
