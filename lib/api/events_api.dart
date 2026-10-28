import 'api_client.dart';
import '../models/decision.dart';

class EventsApi {
  final ApiClient _client;
  EventsApi(this._client);

  Future<List<Decision>> getLiveDecisions() async {
    final resp = await _client.dio.get('/api/events/live');
    return (resp.data as List<dynamic>)
        .map((e) => Decision.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<RecentEvent>> getRecentEvents() async {
    final resp = await _client.dio.get('/api/events/recent');
    return (resp.data as List<dynamic>)
        .map((e) => RecentEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
