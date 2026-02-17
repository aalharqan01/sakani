import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/sakani_empty_state.dart';
import '../../../core/widgets/sakani_error_view.dart';
import '../models/notification_model.dart';
import '../providers/notification_providers.dart';
import '../repositories/notification_repository.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(notificationListProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding, 16, AppSpacing.screenPadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back,
                            size: 24, color: AppColors.navy),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.notifications,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await ref
                          .read(notificationRepositoryProvider)
                          .markAllAsRead();
                      ref.invalidate(notificationListProvider);
                      ref.invalidate(unreadCountProvider);
                    },
                    child: Text(
                      l10n.markAllRead,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return SakaniEmptyState(
                      icon: Icons.notifications_none_outlined,
                      title: l10n.noNotifications,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(notificationListProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _NotificationTile(
                          notification: notification,
                          locale: locale,
                          onTap: () async {
                            if (!notification.isRead) {
                              await ref
                                  .read(notificationRepositoryProvider)
                                  .markAsRead(notification.id);
                              ref.invalidate(notificationListProvider);
                              ref.invalidate(unreadCountProvider);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => SakaniErrorView(
                  message: err.toString(),
                  onRetry: () =>
                      ref.invalidate(notificationListProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final String locale;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = notification.title(locale);
    final body = notification.body(locale);
    final timeStr = _formatTime(notification.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.surface
              : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _typeColor(notification.notificationType)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _typeIcon(notification.notificationType),
                size: 20,
                color: _typeColor(notification.notificationType),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (!notification.isRead)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'cheque_reminder':
        return Icons.schedule;
      case 'cheque_bounced':
        return Icons.error_outline;
      case 'cheque_cleared':
        return Icons.check_circle_outline;
      case 'maintenance_update':
        return Icons.build_outlined;
      case 'maintenance_quote':
        return Icons.request_quote_outlined;
      case 'lease_expiry':
        return Icons.event_outlined;
      case 'announcement':
        return Icons.campaign_outlined;
      case 'system':
      default:
        return Icons.info_outline;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'cheque_reminder':
        return AppColors.warning;
      case 'cheque_bounced':
        return AppColors.error;
      case 'cheque_cleared':
        return AppColors.success;
      case 'maintenance_update':
      case 'maintenance_quote':
        return AppColors.catPurple;
      case 'lease_expiry':
        return AppColors.catAmber;
      case 'announcement':
        return AppColors.chequeDeposited;
      case 'system':
      default:
        return AppColors.primaryDark;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 7) {
      return DateFormat('MMM dd').format(date);
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
