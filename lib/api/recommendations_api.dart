import 'api_client.dart';
import '../models/recommendation.dart';

class RecommendationsApi {
  final ApiClient _client;
  RecommendationsApi(this._client);

  Future<List<Recommendation>> list({String status = 'all'}) async {
    final resp = await _client.dio.get('/api/recommendations', queryParameters: {'status': status});
    return (resp.data as List<dynamic>)
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> approve(
    String id, {
    String? operatorNotes,
    Map<String, dynamic>? edits,
  }) async {
    final resp = await _client.dio.post(
      '/api/recommendations/$id/approve',
      data: {
        if (operatorNotes != null) 'operator_notes': operatorNotes,
        if (edits != null) 'edits': edits,
      },
    );
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> reject(String id, {required String operatorNotes}) async {
    final resp = await _client.dio.post(
      '/api/recommendations/$id/reject',
      data: {'operator_notes': operatorNotes},
    );
    return resp.data as Map<String, dynamic>;
  }
}
