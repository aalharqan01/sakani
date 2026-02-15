import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/maintenance_category_model.dart';
import '../models/maintenance_request_model.dart';
import '../repositories/maintenance_repository.dart';

final maintenanceCategoriesProvider =
    FutureProvider<List<MaintenanceCategoryModel>>((ref) {
  return ref.watch(maintenanceRepositoryProvider).getCategories();
});

final maintenanceRequestsProvider =
    FutureProvider<List<MaintenanceRequestModel>>((ref) {
  return ref.watch(maintenanceRepositoryProvider).getRequests();
});

final maintenanceDetailProvider =
    FutureProvider.family<MaintenanceRequestModel, String>((ref, id) {
  return ref.watch(maintenanceRepositoryProvider).getRequestDetail(id);
});
