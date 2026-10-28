class HealthResponse {
  final String app;
  final String status;
  final String postgres;

  HealthResponse({required this.app, required this.status, required this.postgres});

  factory HealthResponse.fromJson(Map<String, dynamic> json) => HealthResponse(
        app: json['app'] as String? ?? '',
        status: json['status'] as String? ?? 'unknown',
        postgres: json['postgres'] as String? ?? 'unknown',
      );
}

class SystemHealthEntry {
  final String service;
  final bool ok;
  final Map<String, dynamic> raw;

  SystemHealthEntry({required this.service, required this.ok, required this.raw});
}

class KillSwitchResponse {
  final bool enabled;
  final String? reason;

  KillSwitchResponse({required this.enabled, this.reason});

  factory KillSwitchResponse.fromJson(Map<String, dynamic> json) => KillSwitchResponse(
        enabled: json['enabled'] as bool? ?? false,
        reason: json['reason'] as String?,
      );
}

class MeResponse {
  final String email;
  final String name;
  final String role;

  MeResponse({required this.email, required this.name, required this.role});

  factory MeResponse.fromJson(Map<String, dynamic> json) => MeResponse(
        email: json['email'] as String? ?? '',
        name: json['name'] as String? ?? '',
        role: json['role'] as String? ?? '',
      );
}
