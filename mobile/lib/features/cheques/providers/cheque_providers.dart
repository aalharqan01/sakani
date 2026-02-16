import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cheque_dashboard_model.dart';
import '../models/cheque_model.dart';
import '../repositories/cheque_repository.dart';

// Filter state for cheque list
final chequeFilterProvider = StateProvider<String?>((ref) => null);

// Cheque dashboard summary
final chequeDashboardProvider = FutureProvider<ChequeDashboardModel>((ref) {
  return ref.watch(chequeRepositoryProvider).getDashboard();
});

// Cheque list (filtered)
final chequeListProvider = FutureProvider<List<ChequeModel>>((ref) {
  final filter = ref.watch(chequeFilterProvider);
  return ref.watch(chequeRepositoryProvider).getCheques(status: filter);
});

// Upcoming cheques
final upcomingChequesProvider = FutureProvider<List<ChequeModel>>((ref) {
  return ref.watch(chequeRepositoryProvider).getUpcoming();
});

// Single cheque detail
final chequeDetailProvider =
    FutureProvider.family<ChequeModel, String>((ref, id) {
  return ref.watch(chequeRepositoryProvider).getChequeDetail(id);
});
