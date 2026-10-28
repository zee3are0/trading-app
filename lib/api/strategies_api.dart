import 'api_client.dart';
import '../models/strategy.dart';

class StrategiesApi {
  final ApiClient _client;
  StrategiesApi(this._client);

  Future<List<StrategyBundle>> listStrategies() async {
    final resp = await _client.dio.get('/api/strategies');
    return (resp.data as List<dynamic>)
        .map((e) => StrategyBundle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<StrategyPerformanceSummary> getPerformanceSummary() async {
    final resp = await _client.dio.get('/api/strategies/performance-summary');
    return StrategyPerformanceSummary.fromJson(resp.data);
  }

  Future<StrategyBundle> getStrategy(String strategyId) async {
    final resp = await _client.dio.get('/api/strategies/$strategyId');
    return StrategyBundle.fromJson(resp.data);
  }

  Future<Map<String, dynamic>> getCapital(String strategyId) async {
    final resp = await _client.dio.get('/api/strategies/$strategyId/capital');
    return resp.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getPositions(String strategyId, {String? status}) async {
    final resp = await _client.dio.get(
      '/api/strategies/$strategyId/positions',
      queryParameters: status != null ? {'status': status} : null,
    );
    return resp.data as List<dynamic>;
  }
}
