import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/rent_card.dart';
import '../widgets/upcoming_cheques_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              GreetingHeader(name: displayName),
              const RentCard(),
              const SizedBox(height: AppSpacing.xl),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const QuickActionsGrid(),
              const SizedBox(height: AppSpacing.xl),
              const UpcomingChequesSection(),
              const SizedBox(height: AppSpacing.xl),
              const RecentActivitySection(),
            ],
          ),
        ),
      ),
    );
  }
}
