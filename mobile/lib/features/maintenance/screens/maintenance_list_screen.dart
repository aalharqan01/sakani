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
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);

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
                  return GestureDetector(
                    onTap: () => context.go(
                      '${GoRouterState.of(context).matchedLocation}/${active.first.id}',
                    ),
                    child: _ActiveBanner(request: active.first),
                  );
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
              _buildCategoryGrid(context, l10n, categoriesAsync),

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
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.comingSoon),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
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
                  if (requests.isEmpty) {
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
                      children: requests.take(5).map((req) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => context.go(
                              '${GoRouterState.of(context).matchedLocation}/${req.id}',
                            ),
                            child: _HistoryRow(request: req),
                          ),
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

  // Map category name_en to icon and color styling
  static const _categoryStyles = <String, _CategoryStyle>{
    'ac': _CategoryStyle(Icons.thermostat_outlined, AppColors.catBlueSurface, AppColors.catBlue),
    'plumbing': _CategoryStyle(Icons.water_drop_outlined, AppColors.catIndigoSurface, AppColors.catIndigo),
    'electrical': _CategoryStyle(Icons.bolt_outlined, AppColors.catAmberSurface, AppColors.catAmber),
    'general': _CategoryStyle(Icons.build_outlined, AppColors.primarySurface, AppColors.primaryDark),
    'pest control': _CategoryStyle(Icons.pest_control_outlined, AppColors.errorSurface, AppColors.error),
  };

  static const _defaultStyle = _CategoryStyle(Icons.add_box_outlined, AppColors.catPurpleSurface, AppColors.catPurple);

  Widget _buildCategoryGrid(BuildContext context, AppLocalizations l10n, AsyncValue categoriesAsync) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: categoriesAsync.when(
        data: (categories) {
          return GridView.builder(
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
              final style = _categoryStyles[cat.nameEn.toLowerCase()] ?? _defaultStyle;
              return GestureDetector(
                onTap: () => context.pushNamed(
                  RouteNames.createRequest,
                  queryParameters: {
                    'category': cat.id,
                    'categoryName': cat.nameEn,
                  },
                ),
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
                          color: style.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(style.icon, size: 20, color: style.iconColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat.nameEn,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Text(
          l10n.somethingWentWrong,
          style: const TextStyle(color: AppColors.error),
        ),
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

  (Color, Color, IconData, String) _statusInfo(AppLocalizations l10n) {
    switch (request.status) {
      case 'completed' || 'confirmed':
        return (AppColors.successSurface, AppColors.success, Icons.check, l10n.done);
      case 'in_progress':
        return (AppColors.primarySurface, AppColors.primaryDark, Icons.engineering_outlined, l10n.inProgress);
      case 'submitted':
        return (AppColors.warningSurface, AppColors.warning, Icons.schedule, l10n.pending);
      case 'quoted':
        return (AppColors.catBlueSurface, AppColors.catBlue, Icons.request_quote_outlined, l10n.quoted);
      case 'scheduled':
        return (AppColors.catIndigoSurface, AppColors.catIndigo, Icons.calendar_today, l10n.scheduled);
      case 'cancelled':
        return (AppColors.errorSurface, AppColors.error, Icons.cancel_outlined, l10n.cancelled);
      default:
        return (AppColors.creamDark, AppColors.textSecondary, Icons.info_outline, request.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat('MMM dd, yyyy').format(request.createdAt);
    final (bgColor, fgColor, icon, label) = _statusInfo(l10n);

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
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: fgColor),
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
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: fgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStyle {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _CategoryStyle(this.icon, this.bgColor, this.iconColor);
}
