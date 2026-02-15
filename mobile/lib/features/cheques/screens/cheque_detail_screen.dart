import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/cheque_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/cheque_model.dart';
import '../providers/cheque_providers.dart';

class ChequeDetailScreen extends ConsumerWidget {
  final String chequeId;
  const ChequeDetailScreen({required this.chequeId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chequeAsync = ref.watch(chequeDetailProvider(chequeId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: chequeAsync.when(
        data: (cheque) => _ChequeDetailContent(cheque: cheque),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(err.toString()),
              TextButton(
                onPressed: () =>
                    ref.invalidate(chequeDetailProvider(chequeId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChequeDetailContent extends StatelessWidget {
  final ChequeModel cheque;
  const _ChequeDetailContent({required this.cheque});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back,
                          size: 24, color: AppColors.navy),
                      const SizedBox(width: 8),
                      Text(
                        'Cheque Detail',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.more_horiz,
                      size: 20, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 24),
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildTimeline(),
                  const SizedBox(height: 24),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final amountStr = NumberFormat('#,##0', 'en_US').format(cheque.amount);
    final statusLabel = _statusDisplayLabel(cheque.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _statusBgColor(cheque.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _statusDotColor(cheque.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusDotColor(cheque.status),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Currency
          const Text(
            'QAR',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          // Amount
          Text(
            amountStr,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          // Cheque info
          Text(
            'Cheque #${cheque.chequeNumber} \u00B7 ${cheque.bankName}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final dateStr = DateFormat('MMMM dd, yyyy').format(cheque.dueDate);

    final rows = [
      ('Due Date', dateStr),
      ('Bank', cheque.bankName),
      ('Cheque Number', cheque.chequeNumber),
      if (cheque.payeeName != null) ('Payee', cheque.payeeName!),
      if (cheque.unitNumber != null) ('Property', cheque.unitNumber!),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppColors.borderLight),
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.value.$1,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Flexible(
                  child: Text(
                    entry.value.$2,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeline() {
    final items = <_TimelineData>[];

    // Build timeline from status logs if available
    if (cheque.statusLogs != null && cheque.statusLogs!.isNotEmpty) {
      for (final log in cheque.statusLogs!) {
        items.add(_TimelineData(
          title: 'Status: ${log.toStatus}',
          subtitle: DateFormat('MMM dd, yyyy').format(log.createdAt),
          isCompleted: true,
        ));
      }
    } else {
      // Default timeline
      items.addAll([
        _TimelineData(
          title: 'Cheque submitted',
          subtitle: cheque.createdAt != null
              ? DateFormat('MMM dd, yyyy').format(cheque.createdAt!)
              : 'Date unknown',
          isCompleted: true,
        ),
        _TimelineData(
          title: 'Verified by landlord',
          subtitle: 'Verified',
          isCompleted: true,
        ),
        _TimelineData(
          title: 'Awaiting clearing',
          subtitle:
              'Scheduled for ${DateFormat('MMM dd, yyyy').format(cheque.dueDate)}',
          isCurrent: cheque.status == ChequeStatus.pending ||
              cheque.status == ChequeStatus.deposited,
        ),
        _TimelineData(
          title: 'Cleared',
          subtitle: cheque.clearedDate != null
              ? DateFormat('MMM dd, yyyy').format(cheque.clearedDate!)
              : 'Pending',
          isCompleted: cheque.status == ChequeStatus.cleared,
          isFuture: cheque.status != ChequeStatus.cleared,
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == items.length - 1;
            return _buildTimelineItem(item, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(_TimelineData item, bool isLast) {
    Color dotColor;
    Color dotBg;
    IconData icon;

    if (item.isCompleted) {
      dotColor = AppColors.success;
      dotBg = AppColors.successSurface;
      icon = Icons.check;
    } else if (item.isCurrent) {
      dotColor = AppColors.primaryDark;
      dotBg = AppColors.primarySurface;
      icon = Icons.access_time;
    } else {
      dotColor = AppColors.textMuted;
      dotBg = AppColors.creamDark;
      icon = Icons.circle_outlined;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: dotBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: dotColor),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 32,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.isFuture
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Download'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusButton),
                ),
              ),
              icon: const Icon(Icons.email_outlined, size: 18),
              label: const Text('Contact Bank'),
            ),
          ),
        ],
      ),
    );
  }

  String _statusDisplayLabel(ChequeStatus status) {
    switch (status) {
      case ChequeStatus.cleared:
        return 'Cleared';
      case ChequeStatus.bounced:
        return 'Bounced';
      case ChequeStatus.pending:
        return 'Pending';
      case ChequeStatus.deposited:
        return 'Upcoming';
      default:
        return status.name;
    }
  }

  Color _statusBgColor(ChequeStatus status) {
    switch (status) {
      case ChequeStatus.cleared:
        return AppColors.successSurface;
      case ChequeStatus.bounced:
        return AppColors.errorSurface;
      case ChequeStatus.pending:
        return AppColors.goldSurface;
      default:
        return AppColors.primarySurface;
    }
  }

  Color _statusDotColor(ChequeStatus status) {
    switch (status) {
      case ChequeStatus.cleared:
        return AppColors.success;
      case ChequeStatus.bounced:
        return AppColors.error;
      case ChequeStatus.pending:
        return AppColors.warning;
      default:
        return AppColors.primaryDark;
    }
  }
}

class _TimelineData {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final bool isFuture;

  const _TimelineData({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isFuture = false,
  });
}
