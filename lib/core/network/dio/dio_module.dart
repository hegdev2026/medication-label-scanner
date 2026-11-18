import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  /// Shared client. Endpoints are absolute URLs (several public APIs), so no
  /// base URL is set. Certificates are always validated.
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          compact: true,
          maxWidth: 100,
        ),
      );
    }
    return dio;
  }
}
