import 'package:dio/dio.dart';

class RedirectInterceptor extends Interceptor {
  final Dio dio;
  RedirectInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 307 || err.response?.statusCode == 308) {
      String? redirectUrl = err.response?.headers.value('location');
      if (redirectUrl != null) {
        final options = err.requestOptions;
        options.path = redirectUrl;

        if (redirectUrl.startsWith('http')) {
          final uri = Uri.parse(redirectUrl);
          options.baseUrl = '${uri.scheme}://${uri.host}';
          options.path = uri.path;

          if (uri.hasQuery) {
            options.queryParameters = uri.queryParameters;
          }
        }
        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          if (e is DioException) {
            return handler.next(e);
          }
        }
      }
    }

    return handler.next(err);
  }
}
