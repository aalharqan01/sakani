import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exceptions.dart';
import '../models/maintenance_category_model.dart';
import '../models/maintenance_request_model.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  return MaintenanceRepository(dio: ref.watch(dioProvider));
});

class MaintenanceRepository {
  final Dio _dio;

  MaintenanceRepository({required Dio dio}) : _dio = dio;

  Future<List<MaintenanceCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.maintenanceCategories);
      final results = response.data is List
          ? response.data as List
          : (response.data['results'] as List?) ?? [];
      return results
          .map((e) =>
              MaintenanceCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<MaintenanceRequestModel>> getRequests({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        ApiEndpoints.maintenanceRequests,
        queryParameters: queryParams,
      );

      final results = response.data is List
          ? response.data as List
          : (response.data['results'] as List?) ?? [];
      return results
          .map((e) =>
              MaintenanceRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<MaintenanceRequestModel> getRequestDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.maintenanceDetail(id));
      return MaintenanceRequestModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<MaintenanceRequestModel> createRequest({
    required String unitId,
    String? categoryId,
    required String title,
    required String description,
    String urgency = 'routine',
    DateTime? preferredDate1,
    DateTime? preferredDate2,
    String? preferredTimeSlot,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.maintenanceRequests,
        data: {
          'unit': unitId,
          if (categoryId != null) 'category': categoryId,
          'title': title,
          'description': description,
          'urgency': urgency,
          if (preferredDate1 != null)
            'preferred_date_1':
                preferredDate1.toIso8601String().split('T').first,
          if (preferredDate2 != null)
            'preferred_date_2':
                preferredDate2.toIso8601String().split('T').first,
          if (preferredTimeSlot != null)
            'preferred_time_slot': preferredTimeSlot,
        },
      );
      return MaintenanceRequestModel.fromJson(
          response.data as Map<String, dynamic>);
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
