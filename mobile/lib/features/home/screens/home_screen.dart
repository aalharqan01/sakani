import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/doha_skyline_painter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../notifications/providers/notification_providers.dart';
import '../../notifications/screens/notification_list_screen.dart'
    as notifications;
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/rent_card.dart';
import '../widgets/upcoming_cheques_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? '';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(context, displayName),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding),
              child: Text(
                l10n.quickActions,
                style: const TextStyle(
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
    );
  }

  Widget _buildHero(BuildContext context, String displayName) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.6, -0.8),
          end: Alignment(0.8, 0.6),
          colors: [AppColors.navy, AppColors.navyLight, Color(0xFF4338CA)],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Doha skyline silhouette
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: CustomPaint(
              painter: DohaSkylinePainter(
                color: const Color(0x18A5B4FC),
              ),
            ),
          ),
          // Subtle glow circle
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x0E818CF8),
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _GreetingHeaderDark(name: displayName),
                  const RentCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark-themed greeting header for use on the navy gradient hero.
class _GreetingHeaderDark extends ConsumerWidget {
  final String name;
  const _GreetingHeaderDark({required this.name});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(l10n).toUpperCase(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Notification bell
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const _NotificationsPage(),
              ),
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_outlined,
                      size: 24, color: Colors.white),
                  if (unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.navy, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper to push the notification screen via MaterialPageRoute
/// (avoids GoRouter dependency for a simple push).
class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage();
  @override
  Widget build(BuildContext context) {
    // Lazy import avoids circular dependency
    return const _NotificationScreenLoader();
  }
}

class _NotificationScreenLoader extends StatelessWidget {
  const _NotificationScreenLoader();
  @override
  Widget build(BuildContext context) {
    // Import at usage site
    return const notifications.NotificationListScreen();
  }
}
