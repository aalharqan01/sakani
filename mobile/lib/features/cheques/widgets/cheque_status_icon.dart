import 'package:flutter/material.dart';
import '../../../core/enums/cheque_status.dart';
import '../../../core/theme/app_colors.dart';

class ChequeStatusIcon extends StatelessWidget {
  final ChequeStatus status;
  final double size;

  const ChequeStatusIcon({
    required this.status,
    this.size = 38,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(_icon, size: size * 0.47, color: _iconColor),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case ChequeStatus.cleared:
        return AppColors.successSurface;
      case ChequeStatus.bounced:
        return AppColors.errorSurface;
      case ChequeStatus.pending:
        return AppColors.goldSurface;
      case ChequeStatus.deposited:
        return AppColors.primarySurface;
      default:
        return AppColors.creamDark;
    }
  }

  Color get _iconColor {
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

  IconData get _icon {
    switch (status) {
      case ChequeStatus.cleared:
        return Icons.check_circle_outline;
      case ChequeStatus.bounced:
        return Icons.warning_amber_rounded;
      case ChequeStatus.pending:
        return Icons.receipt_long_rounded;
      case ChequeStatus.deposited:
        return Icons.receipt_long_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }
}
