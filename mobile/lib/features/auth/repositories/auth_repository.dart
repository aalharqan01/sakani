import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exceptions.dart';
import '../../../core/auth/token_storage.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

class AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepository({
    required Dio dio,
    required TokenStorage tokenStorage,
  })  : _dio = dio,
        _tokenStorage = tokenStorage;

  /// Login with phone number and password. Returns user on success.
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'phone_number': phoneNumber,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await _tokenStorage.saveTokens(
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String,
      );

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Register a new user. Returns user on success.
  Future<UserModel> register({
    required String phoneNumber,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
    String? fullNameEn,
    String? fullNameAr,
    String? email,
    String role = 'tenant',
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'phone_number': phoneNumber,
          'password': password,
          'password_confirm': passwordConfirm,
          'first_name': firstName,
          'last_name': lastName,
          if (fullNameEn != null) 'full_name_en': fullNameEn,
          if (fullNameAr != null) 'full_name_ar': fullNameAr,
          if (email != null) 'email': email,
          'role': role,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await _tokenStorage.saveTokens(
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String,
      );

      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get current user profile.
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Logout - blacklist refresh token and clear local storage.
  Future<void> logout() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _dio.post(
          ApiEndpoints.logout,
          data: {'refresh': refreshToken},
        );
      }
    } catch (_) {
      // Ignore logout API errors - clear tokens regardless
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  /// Check if user has a valid session (tokens stored).
  Future<bool> hasSession() async {
    return _tokenStorage.hasTokens();
  }

  ApiException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 401) {
      return const UnauthorizedException();
    }

    if (statusCode == 400 && data is Map<String, dynamic>) {
      final fieldErrors = <String, List<String>>{};
      data.forEach((key, value) {
        if (value is List) {
          fieldErrors[key] = value.map((e) => e.toString()).toList();
        } else if (value is String) {
          fieldErrors[key] = [value];
        }
      });

      final message = fieldErrors.values.expand((e) => e).firstOrNull ??
          'Validation error';
      return ValidationException(message, fieldErrors: fieldErrors);
    }

    return ServerException(
      data?['detail']?.toString() ?? 'Something went wrong',
      statusCode: statusCode,
    );
  }
}
