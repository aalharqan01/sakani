import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/sakani_error_view.dart';
import '../models/maintenance_request_model.dart';
import '../providers/maintenance_providers.dart';

class MaintenanceListScreen extends ConsumerWidget {
  const MaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final requestsAsync = ref.watch(maintenanceRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding, 16, AppSpacing.screenPadding, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.maintenance,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.createRequest),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              l10n.newRequest,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Active request banner
              requestsAsync.when(
                data: (requests) {
                  final active =
                      requests.where((r) => r.isActive).toList();
                  if (active.isEmpty) return const SizedBox.shrink();
                  return _ActiveBanner(request: active.first);
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // Service categories
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding, 24, AppSpacing.screenPadding, 0),
                child: Text(
                  l10n.serviceCategories,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoryGrid(l10n),

              // History
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding, 24, AppSpacing.screenPadding, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.historySection,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        l10n.seeAll,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              requestsAsync.when(
                data: (requests) {
                  final completed =
                      requests.where((r) => r.isCompleted).toList();
                  if (completed.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding),
                      child: Text(
                        l10n.noCompletedRequests,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 13),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding),
                    child: Column(
                      children: completed.take(5).map((req) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _HistoryRow(request: req),
                        );
                      }).toList(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => SakaniErrorView(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(maintenanceRequestsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(AppLocalizations l10n) {
    final categories = [
      _CategoryItem(
        icon: Icons.thermostat_outlined,
        label: l10n.categoryAc,
        bgColor: AppColors.catBlueSurface,
        iconColor: AppColors.catBlue,
      ),
      _CategoryItem(
        icon: Icons.water_drop_outlined,
        label: l10n.categoryPlumbing,
        bgColor: AppColors.catIndigoSurface,
        iconColor: AppColors.catIndigo,
      ),
      _CategoryItem(
        icon: Icons.bolt_outlined,
        label: l10n.categoryElectrical,
        bgColor: AppColors.catAmberSurface,
        iconColor: AppColors.catAmber,
      ),
      _CategoryItem(
        icon: Icons.build_outlined,
        label: l10n.categoryGeneral,
        bgColor: AppColors.primarySurface,
        iconColor: AppColors.primaryDark,
      ),
      _CategoryItem(
        icon: Icons.pest_control_outlined,
        label: l10n.categoryPestControl,
        bgColor: AppColors.errorSurface,
        iconColor: AppColors.error,
      ),
      _CategoryItem(
        icon: Icons.add_box_outlined,
        label: l10n.categoryOther,
        bgColor: AppColors.catPurpleSurface,
        iconColor: AppColors.catPurple,
      ),
    ];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => context.pushNamed(RouteNames.createRequest),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(cat.icon, size: 20, color: cat.iconColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cat.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActiveBanner extends StatelessWidget {
  final MaintenanceRequestModel request;
  const _ActiveBanner({required this.request});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.goldSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.engineering_outlined,
                size: 20, color: AppColors.warning),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${request.title} — ${l10n.inProgress}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  request.scheduledDate != null
                      ? l10n.scheduledForDate(DateFormat('MMM dd, h:mm a').format(request.scheduledDate!))
                      : l10n.inProgress,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final MaintenanceRequestModel request;
  const _HistoryRow({required this.request});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat('MMM dd, yyyy').format(request.createdAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.successSurface,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.check, size: 18, color: AppColors.success),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              l10n.done.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
  });
}
