import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

final notificationListProvider =
    FutureProvider<List<NotificationModel>>((ref) {
  return ref.watch(notificationRepositoryProvider).getNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) {
  return ref.watch(notificationRepositoryProvider).getUnreadCount();
});
