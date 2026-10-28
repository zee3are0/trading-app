import 'api_client.dart';
import '../models/health.dart';

class HealthApi {
  final ApiClient _client;
  HealthApi(this._client);

  Future<HealthResponse> getHealth() async {
    final resp = await _client.dio.get('/api/health');
    return HealthResponse.fromJson(resp.data);
  }

  Future<Map<String, dynamic>> getSystemHealth() async {
    final resp = await _client.dio.get('/api/health/system');
    return resp.data as Map<String, dynamic>;
  }

  Future<MeResponse> getMe() async {
    final resp = await _client.dio.get('/api/me');
    return MeResponse.fromJson(resp.data);
  }
}
