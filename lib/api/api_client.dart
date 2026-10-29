import 'package:dio/dio.dart';
import '../auth/auth_provider.dart';
import '../config.dart';

class ApiClient {
  late final Dio dio;
  final AuthProvider _auth;

  ApiClient(this._auth) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.httpTimeout,
      receiveTimeout: AppConfig.httpTimeout,
      headers: {'Accept': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _auth.getValidToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            error.requestOptions.extra['_retried'] != true) {
          final token = await _auth.getValidToken();
          if (token != null) {
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            error.requestOptions.extra['_retried'] = true;
            final retryResponse = await dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        handler.next(error);
      },
    ));
  }
}
