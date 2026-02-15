import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../cheques/providers/cheque_providers.dart';

class RentCard extends ConsumerWidget {
  const RentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(chequeDashboardProvider);
    final upcomingAsync = ref.watch(upcomingChequesProvider);

    // Default values for display
    double amount = 8500;
    String dueDate = 'Due soon';
    int cleared = 0;
    int total = 12;
    double progress = 0;

    dashboardAsync.whenData((data) {
      cleared = data.cleared;
      total = data.total > 0 ? data.total : 12;
      progress = total > 0 ? cleared / total : 0;
    });

    upcomingAsync.whenData((list) {
      if (list.isNotEmpty) {
        final next = list.first;
        amount = next.amount;
        dueDate = 'Due ${DateFormat('MMMM dd, yyyy').format(next.dueDate)}';
      }
    });

    final amountStr = NumberFormat('#,##0', 'en_US').format(amount);
    final pctStr = '${(progress * 100).round()}%';

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding, 18, AppSpacing.screenPadding, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyLight],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.25),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Payment',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.secondarySeed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'On Track',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Currency
          Text(
            'QAR',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 4),
          // Amount
          Text(
            amountStr,
            style: const TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 4),
          // Due date
          Text(
            dueDate,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$cleared of $total cheques cleared',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
              Text(
                pctStr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondarySeed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.secondarySeed),
            ),
          ),
        ],
      ),
    );
  }
}
