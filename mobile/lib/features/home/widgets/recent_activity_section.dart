import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/cheque_status.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../cheques/providers/cheque_providers.dart';
import '../../maintenance/providers/maintenance_providers.dart';

class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chequesAsync = ref.watch(chequeListProvider);
    final maintenanceAsync = ref.watch(maintenanceRequestsProvider);

    // Merge recent cheques + maintenance into a single activity list
    final activities = <_ActivityData>[];

    chequesAsync.whenData((cheques) {
      for (final c in cheques.take(3)) {
        final statusLabel = c.status == ChequeStatus.cleared
            ? l10n.chequeStatusCleared
            : c.status == ChequeStatus.bounced
                ? l10n.chequeStatusBounced
                : l10n.chequeStatusPending;
        activities.add(_ActivityData(
          icon: c.status == ChequeStatus.cleared
              ? Icons.check_circle_outline
              : c.status == ChequeStatus.bounced
                  ? Icons.error_outline
                  : Icons.schedule,
          iconColor: c.status == ChequeStatus.cleared
              ? AppColors.success
              : c.status == ChequeStatus.bounced
                  ? AppColors.error
                  : AppColors.warning,
          bgColor: c.status == ChequeStatus.cleared
              ? AppColors.successSurface
              : c.status == ChequeStatus.bounced
                  ? AppColors.errorSurface
                  : AppColors.warningSurface,
          title: '${l10n.chequeNumberLabel(c.chequeNumber)} — $statusLabel',
          time: _timeAgo(c.createdAt ?? c.dueDate, l10n),
          date: c.createdAt ?? c.dueDate,
        ));
      }
    });

    maintenanceAsync.whenData((requests) {
      for (final r in requests.take(3)) {
        activities.add(_ActivityData(
          icon: r.isCompleted
              ? Icons.check_circle_outline
              : Icons.build_outlined,
          iconColor:
              r.isCompleted ? AppColors.success : AppColors.catPurple,
          bgColor: r.isCompleted
              ? AppColors.successSurface
              : AppColors.catPurpleSurface,
          title:
              '${r.title} — ${r.isCompleted ? l10n.done : l10n.inProgress}',
          time: _timeAgo(r.createdAt, l10n),
          date: r.createdAt,
        ));
      }
    });

    // Sort by date descending, take most recent 5
    activities.sort((a, b) => b.date.compareTo(a.date));
    final recentItems = activities.take(5).toList();

    final isLoading =
        chequesAsync.isLoading || maintenanceAsync.isLoading;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recentActivity,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          if (isLoading)
            const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (recentItems.isEmpty)
            Text(
              l10n.noItemsYet,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13),
            )
          else
            ...recentItems.asMap().entries.map((entry) {
              final activity = entry.value;
              final isLast = entry.key == recentItems.length - 1;
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: activity.bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(activity.icon,
                            size: 18, color: activity.iconColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              activity.time,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.only(left: 52),
                      child: Container(
                        height: 1,
                        margin:
                            const EdgeInsets.symmetric(vertical: 14),
                        color: AppColors.borderLight,
                      ),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 30) {
      return DateFormat('MMM dd').format(date);
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}

class _ActivityData {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String time;
  final DateTime date;

  const _ActivityData({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.time,
    required this.date,
  });
}
