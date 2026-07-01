import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService({required String baseUrl, String? token}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 3),
        sendTimeout: Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<Response> get({
    required String endPoint,
    dynamic data,
    dynamic params,
  }) async {
    var response = await _dio.get(
      endPoint,
      data: data,
      queryParameters: params,
    );
    return response;
  }

  Future<Response> post({
    required String endPoint,
    dynamic data,
    dynamic params,
  }) async {
    var response = await _dio.post(
      endPoint,
      data: data,
      queryParameters: params,
    );
    return response;
  }

  Future<Response> put({required String endPoint}) async {
    var response = await _dio.put(endPoint);
    return response;
  }

  Future<Response> delete({required String endPoint}) async {
    var response = await _dio.delete(endPoint);
    return response;
  }
}
