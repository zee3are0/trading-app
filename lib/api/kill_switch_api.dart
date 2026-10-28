import 'api_client.dart';
import '../models/health.dart';

class KillSwitchApi {
  final ApiClient _client;
  KillSwitchApi(this._client);

  Future<KillSwitchResponse> getStatus() async {
    final resp = await _client.dio.get('/api/kill-switch');
    return KillSwitchResponse.fromJson(resp.data);
  }

  Future<KillSwitchResponse> turnOn({String? reason}) async {
    final resp = await _client.dio.post('/api/kill-switch/on', data: {'reason': reason});
    return KillSwitchResponse.fromJson(resp.data);
  }

  Future<KillSwitchResponse> turnOff({String? reason}) async {
    final resp = await _client.dio.post('/api/kill-switch/off', data: {'reason': reason});
    return KillSwitchResponse.fromJson(resp.data);
  }
}
