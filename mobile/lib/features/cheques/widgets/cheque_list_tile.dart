import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/cheque_status.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/cheque_model.dart';
import 'cheque_status_icon.dart';

class ChequeListTile extends StatelessWidget {
  final ChequeModel cheque;
  final VoidCallback? onTap;

  const ChequeListTile({
    required this.cheque,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isBounced = cheque.status == ChequeStatus.bounced;
    final dateStr = DateFormat('MMM dd, yyyy').format(cheque.dueDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: isBounced
              ? Border.all(color: AppColors.error, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ChequeStatusIcon(status: cheque.status),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chequeNumberLabel(cheque.chequeNumber),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isBounced
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dateStr \u00B7 ${_statusLabel(l10n, cheque.status)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: _statusColor(cheque.status),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatAmount(cheque.amount),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isBounced ? AppColors.error : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  String _statusLabel(AppLocalizations l10n, ChequeStatus status) {
    switch (status) {
      case ChequeStatus.cleared:
        return l10n.chequeStatusCleared;
      case ChequeStatus.bounced:
        return l10n.chequeStatusBounced;
      case ChequeStatus.pending:
        return l10n.chequeStatusPending;
      case ChequeStatus.deposited:
        return l10n.upcoming;
      default:
        return status.name[0].toUpperCase() + status.name.substring(1);
    }
  }

  Color _statusColor(ChequeStatus status) {
    switch (status) {
      case ChequeStatus.cleared:
        return AppColors.success;
      case ChequeStatus.bounced:
        return AppColors.error;
      case ChequeStatus.pending:
        return AppColors.warning;
      case ChequeStatus.deposited:
        return AppColors.primaryDark;
      default:
        return AppColors.textMuted;
    }
  }
}
