class Recommendation {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String status;
  final String recommendationType;
  final String symbol;
  final String portfolioBucket;
  final String strategyName;
  final String? sourceStrategy;
  final String? proposedBarTimeframe;
  final String? proposedChannelMethod;
  final String? proposedRiskBucket;
  final bool? proposedEnabled;
  final double? confidence;
  final double? priorityScore;
  final String summary;
  final String? parentheticalSummary;
  final String reasonCode;
  final String reasonDetail;
  final String llmModel;
  final String promptVersion;
  final String researchDepth;
  final Map<String, dynamic>? inputContextJson;
  final Map<String, dynamic> proposedPayloadJson;
  final Map<String, dynamic>? evidenceSummaryJson;
  final Map<String, dynamic> metadataJson;
  final String? approvedBy;
  final String? approvedAt;
  final String? rejectedBy;
  final String? rejectedAt;

  Recommendation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.recommendationType,
    required this.symbol,
    required this.portfolioBucket,
    required this.strategyName,
    this.sourceStrategy,
    this.proposedBarTimeframe,
    this.proposedChannelMethod,
    this.proposedRiskBucket,
    this.proposedEnabled,
    this.confidence,
    this.priorityScore,
    required this.summary,
    this.parentheticalSummary,
    required this.reasonCode,
    required this.reasonDetail,
    required this.llmModel,
    required this.promptVersion,
    required this.researchDepth,
    this.inputContextJson,
    required this.proposedPayloadJson,
    this.evidenceSummaryJson,
    required this.metadataJson,
    this.approvedBy,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedAt,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
        id: json['id'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
        updatedAt: json['updated_at'] as String? ?? '',
        status: json['status'] as String? ?? '',
        recommendationType: json['recommendation_type'] as String? ?? '',
        symbol: json['symbol'] as String? ?? '',
        portfolioBucket: json['portfolio_bucket'] as String? ?? '',
        strategyName: json['strategy_name'] as String? ?? '',
        sourceStrategy: json['source_strategy'] as String?,
        proposedBarTimeframe: json['proposed_bar_timeframe'] as String?,
        proposedChannelMethod: json['proposed_channel_method'] as String?,
        proposedRiskBucket: json['proposed_risk_bucket'] as String?,
        proposedEnabled: json['proposed_enabled'] as bool?,
        confidence: (json['confidence'] as num?)?.toDouble(),
        priorityScore: (json['priority_score'] as num?)?.toDouble(),
        summary: json['summary'] as String? ?? '',
        parentheticalSummary: json['parenthetical_summary'] as String?,
        reasonCode: json['reason_code'] as String? ?? '',
        reasonDetail: json['reason_detail'] as String? ?? '',
        llmModel: json['llm_model'] as String? ?? '',
        promptVersion: json['prompt_version'] as String? ?? '',
        researchDepth: json['research_depth'] as String? ?? '',
        inputContextJson: json['input_context_json'] as Map<String, dynamic>?,
        proposedPayloadJson: json['proposed_payload_json'] as Map<String, dynamic>? ?? {},
        evidenceSummaryJson: json['evidence_summary_json'] as Map<String, dynamic>?,
        metadataJson: json['metadata_json'] as Map<String, dynamic>? ?? {},
        approvedBy: json['approved_by'] as String?,
        approvedAt: json['approved_at'] as String?,
        rejectedBy: json['rejected_by'] as String?,
        rejectedAt: json['rejected_at'] as String?,
      );

  bool get isPending => status == 'pending_review';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
