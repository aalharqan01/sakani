import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/router/route_names.dart';
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
        onTap: () => _showComingSoon(context, l10n),
      ),
      _QuickAction(
        icon: Icons.credit_card_outlined,
        label: l10n.payRent,
        bgColor: AppColors.goldSurface,
        iconColor: AppColors.warning,
        onTap: () => context.go('/tenant/cheques'),
      ),
      _QuickAction(
        icon: Icons.build_outlined,
        label: l10n.repair,
        bgColor: AppColors.catPurpleSurface,
        iconColor: AppColors.catPurple,
        onTap: () => context.pushNamed(RouteNames.createRequest),
      ),
      _QuickAction(
        icon: Icons.bolt_outlined,
        label: l10n.utilities,
        bgColor: AppColors.errorSurface,
        iconColor: AppColors.error,
        onTap: () => _showComingSoon(context, l10n),
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

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildActionItem(_QuickAction action) {
    return Expanded(
      child: GestureDetector(
        onTap: action.onTap,
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
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}
