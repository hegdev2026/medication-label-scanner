import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Compact request/response log lines. Only added in debug builds.
class LoggerInterceptor extends Interceptor {
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('${options.method} ==> ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('${response.statusCode} <== ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('${err.requestOptions.method} ${err.requestOptions.uri}');
    logger.d('${err.type}: ${err.message}');
    handler.next(err);
  }
}
