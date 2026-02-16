import 'package:flutter/material.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actions = [
      _QuickAction(
        icon: Icons.camera_alt_outlined,
        label: l10n.scan,
        bgColor: AppColors.primarySurface,
        iconColor: AppColors.primaryDark,
      ),
      _QuickAction(
        icon: Icons.credit_card_outlined,
        label: l10n.payRent,
        bgColor: AppColors.goldSurface,
        iconColor: AppColors.warning,
      ),
      _QuickAction(
        icon: Icons.build_outlined,
        label: l10n.repair,
        bgColor: AppColors.catPurpleSurface,
        iconColor: AppColors.catPurple,
      ),
      _QuickAction(
        icon: Icons.bolt_outlined,
        label: l10n.utilities,
        bgColor: AppColors.errorSurface,
        iconColor: AppColors.error,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding, 16, AppSpacing.screenPadding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return _buildActionItem(action);
        }).toList(),
      ),
    );
  }

  Widget _buildActionItem(_QuickAction action) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: action.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(action.icon, size: 20, color: action.iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
  });
}
