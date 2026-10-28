import 'api_client.dart';
import '../models/broker.dart';

class BrokerApi {
  final ApiClient _client;
  BrokerApi(this._client);

  Future<BrokerAlpacaSummary> getAlpacaSummary() async {
    final resp = await _client.dio.get('/api/broker/alpaca/summary');
    return BrokerAlpacaSummary.fromJson(resp.data);
  }

  Future<IBKRSummary> getIbkrSummary() async {
    final resp = await _client.dio.get('/api/broker/ibkr/summary');
    return IBKRSummary.fromJson(resp.data);
  }

  Future<List<BrokerStatusEntry>> getStatus() async {
    final resp = await _client.dio.get('/api/broker/status');
    final data = resp.data as Map<String, dynamic>;
    return (data['brokers'] as List<dynamic>)
        .map((e) => BrokerStatusEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getStrategySummary() async {
    final resp = await _client.dio.get('/api/broker/strategy-summary');
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markToMarket() async {
    final resp = await _client.dio.post('/api/broker/mark-to-market');
    return resp.data as Map<String, dynamic>;
  }
}
