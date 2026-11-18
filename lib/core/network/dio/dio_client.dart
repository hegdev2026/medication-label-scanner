import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/network/dio/logger_interceptor.dart';
import 'package:medicine_lab_reader/core/network/network_info.dart';

/// Thrown instead of waiting when the device has no connection.
class OfflineException implements Exception {
  const OfflineException();
}

/// Thin wrapper over [Dio]: connectivity check, then the request.
@lazySingleton
class DioClient {
  DioClient(this._dio, this._networkInfo) {
    _dio.interceptors.add(LoggerInterceptor());
  }

  final Dio _dio;
  final NetworkInfo _networkInfo;

  /// GET. With [retries] above 0, a 429 (too many requests) or 503 is retried
  /// after the server's Retry-After (at most 4 s) or a growing pause.
  Future<Response<dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int retries = 0,
  }) async {
    if (!await _networkInfo.isConnected) throw const OfflineException();
    for (var attempt = 0; ; attempt++) {
      try {
        return await _dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
        );
      } on DioException catch (e) {
        final code = e.response?.statusCode;
        if (attempt >= retries || (code != 429 && code != 503)) rethrow;
        await Future<void>.delayed(_pause(e.response, attempt));
      }
    }
  }

  static Duration _pause(Response<dynamic>? res, int attempt) {
    final header = int.tryParse(res?.headers.value('retry-after') ?? '');
    final seconds = header ?? (attempt + 1);
    return Duration(seconds: seconds.clamp(1, 4));
  }

  /// Sends a multipart form (for example a photo plus a few fields).
  Future<Response<dynamic>> postForm(
    String url,
    FormData form, {
    Map<String, String>? headers,
    Duration receiveTimeout = const Duration(seconds: 60),
  }) async {
    if (!await _networkInfo.isConnected) throw const OfflineException();
    return _dio.post(
      url,
      data: form,
      options: Options(
        headers: headers,
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: receiveTimeout,
      ),
    );
  }
}
