import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Static recent activity for now — will be wired to API later
    final activities = [
      _ActivityData(
        icon: Icons.check_circle_outline,
        iconColor: AppColors.success,
        bgColor: AppColors.successSurface,
        title: 'Cheque #003 cleared',
        time: '2 days ago',
      ),
      _ActivityData(
        icon: Icons.build_outlined,
        iconColor: AppColors.catPurple,
        bgColor: AppColors.catPurpleSurface,
        title: 'AC repair completed',
        time: '5 days ago',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...activities.asMap().entries.map((entry) {
            final activity = entry.value;
            final isLast = entry.key == activities.length - 1;
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
                      margin: const EdgeInsets.symmetric(vertical: 14),
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
}

class _ActivityData {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String time;

  const _ActivityData({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.time,
  });
}
