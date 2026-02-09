import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../auth/token_storage.dart';
import 'api_endpoints.dart';

/// Adds JWT access token to requests; refreshes on 401.
class AuthInterceptor extends QueuedInterceptor {
  final Ref _ref;

  AuthInterceptor({required Ref ref}) : _ref = ref;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokenStorage = _ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final tokenStorage = _ref.read(tokenStorageProvider);
        final refreshToken = await tokenStorage.getRefreshToken();

        if (refreshToken == null) {
          await tokenStorage.clearTokens();
          return handler.next(err);
        }

        // Refresh using a clean Dio instance
        final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
        final response = await refreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh': refreshToken},
        );

        final newAccess = response.data['access'] as String;
        final newRefresh = response.data['refresh'] as String?;
        await tokenStorage.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh ?? refreshToken,
        );

        // Retry original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
        final retryResponse = await refreshDio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        final tokenStorage = _ref.read(tokenStorageProvider);
        await tokenStorage.clearTokens();
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}

/// Adds Accept-Language header based on current locale.
class LanguageInterceptor extends Interceptor {
  final Ref _ref;

  LanguageInterceptor({required Ref ref}) : _ref = ref;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    final locale = _ref.read(localeProvider);
    options.headers['Accept-Language'] = locale.languageCode;
    handler.next(options);
  }
}
