import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  final String _accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMzI2ZmZmNjU4ZjQ5MGM4ZTQ2NGE2ZmEzMjY0MmNhNyIsIm5iZiI6MTU1NTA1ODE4NC4wMiwic3ViIjoiNWNiMDRlMDgwZTBhMjYyNmU5YzQwYjRlIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.JpS--miQmwNBnLx92U-auWGZMyomA5A9acMDMbXf5R8";

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://api.themoviedb.org/3/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool useToken = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: _mergeHeaders(headers, useToken)),
      );
      return response;
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool useToken = true,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _mergeHeaders(headers, useToken)),
      );
      return response;
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Map<String, dynamic> _mergeHeaders(
    Map<String, dynamic>? additionalHeaders,
    bool useToken,
  ) {
    final defaultHeaders = {
      if (useToken) "Authorization": "Bearer $_accessToken",
    };
    return {
      ...defaultHeaders,
      if (additionalHeaders != null) ...additionalHeaders,
    };
  }

  void _handleDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionTimeout:
        throw Exception("Connection timeout, please try again.");
      case DioErrorType.receiveTimeout:
        throw Exception("Receive timeout, please try again.");
      case DioErrorType.badResponse:
        throw Exception(
          "Received invalid status code: ${error.response?.statusCode}",
        );
      case DioErrorType.unknown:
        throw Exception("Unexpected error: ${error.message}");
      case DioErrorType.sendTimeout:
        throw Exception("Send timeout, please try again.");
      case DioErrorType.badCertificate:
        throw Exception("Bad certificate encountered.");
      case DioErrorType.cancel:
        throw Exception("Request was cancelled.");
      default:
        throw Exception("An error occurred: ${error.message}");
    }
  }
}