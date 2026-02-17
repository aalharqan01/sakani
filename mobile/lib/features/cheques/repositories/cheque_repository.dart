import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exceptions.dart';
import '../models/cheque_dashboard_model.dart';
import '../models/cheque_model.dart';

final chequeRepositoryProvider = Provider<ChequeRepository>((ref) {
  return ChequeRepository(dio: ref.watch(dioProvider));
});

class ChequeRepository {
  final Dio _dio;

  ChequeRepository({required Dio dio}) : _dio = dio;

  Future<List<ChequeModel>> getCheques({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        ApiEndpoints.cheques,
        queryParameters: queryParams,
      );

      final results = response.data is List
          ? response.data as List
          : (response.data['results'] as List?) ?? [];

      return results
          .map((e) => ChequeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ChequeModel> getChequeDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.chequeDetail(id));
      return ChequeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ChequeDashboardModel> getDashboard() async {
    try {
      final response = await _dio.get(ApiEndpoints.chequeDashboard);
      return ChequeDashboardModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<ChequeModel>> getUpcoming() async {
    try {
      final response = await _dio.get(ApiEndpoints.chequeUpcoming);
      final results = response.data is List
          ? response.data as List
          : (response.data['results'] as List?) ?? [];
      return results
          .map((e) => ChequeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<ChequeModel>> getOverdue() async {
    try {
      final response = await _dio.get(ApiEndpoints.chequeOverdue);
      final results = response.data is List
          ? response.data as List
          : (response.data['results'] as List?) ?? [];
      return results
          .map((e) => ChequeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ChequeModel> depositCheque(String id, {String? notes}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.chequeDeposit(id),
        data: {'notes': notes ?? ''},
      );
      return ChequeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ChequeModel> clearCheque(String id, {String? notes}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.chequeClear(id),
        data: {'notes': notes ?? ''},
      );
      return ChequeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ChequeModel> bounceCheque(
    String id, {
    String? bounceReason,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.chequeBounce(id),
        data: {
          'bounce_reason': bounceReason ?? '',
          'notes': notes ?? '',
        },
      );
      return ChequeModel.fromJson(response.data as Map<String, dynamic>);
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
