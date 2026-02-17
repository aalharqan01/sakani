import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exceptions.dart';
import '../models/notification_model.dart';

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepository(dio: ref.watch(dioProvider));
});

class NotificationRepository {
  final Dio _dio;

  NotificationRepository({required Dio dio}) : _dio = dio;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.notifications);
      final results = response.data is List
          ? response.data as List
          : (response.data['results'] as List?) ?? [];
      return results
          .map((e) =>
              NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiEndpoints.notificationsUnreadCount);
      return (response.data['count'] as int?) ?? 0;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _dio.post(ApiEndpoints.notificationRead(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.post(ApiEndpoints.notificationsReadAll);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> registerDevice({
    required String token,
    required String deviceType,
    String? deviceName,
  }) async {
    try {
      await _dio.post(ApiEndpoints.devices, data: {
        'token': token,
        'device_type': deviceType,
        'device_name': deviceName ?? '',
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    if (statusCode == 401) return const UnauthorizedException();
    return ServerException(
      data?['detail']?.toString() ?? 'Something went wrong',
      statusCode: statusCode,
    );
  }
}
