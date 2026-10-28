import 'api_client.dart';

class ChatApi {
  final ApiClient _client;
  ChatApi(this._client);

  Future<Map<String, dynamic>> send(String message, {List<Map<String, String>>? history}) async {
    final resp = await _client.dio.post('/api/chat/message', data: {
      'message': message,
      if (history != null) 'history': history,
    });
    return resp.data as Map<String, dynamic>;
  }
}
