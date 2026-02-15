import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/cheque_providers.dart';
import '../widgets/cheque_list_tile.dart';
import '../widgets/cheque_summary_card.dart';

class ChequeListScreen extends ConsumerStatefulWidget {
  const ChequeListScreen({super.key});

  @override
  ConsumerState<ChequeListScreen> createState() => _ChequeListScreenState();
}

class _ChequeListScreenState extends ConsumerState<ChequeListScreen> {
  int _selectedSegment = 0;
  final _segments = ['All', 'Upcoming', 'Cleared'];

  @override
  Widget build(BuildContext context) {
    final cheques = ref.watch(chequeListProvider);
    final dashboard = ref.watch(chequeDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 16, AppSpacing.screenPadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cheques',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Scan',
                            style: TextStyle(
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

            // Summary cards
            dashboard.when(
              data: (data) => Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding, 18, AppSpacing.screenPadding, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: ChequeSummaryCard(
                        label: 'Cleared',
                        value: data.cleared,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChequeSummaryCard(
                        label: 'Pending',
                        value: data.pending,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ChequeSummaryCard(
                        label: 'Bounced',
                        value: data.bounced,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding),
                child: Row(
                  children: [
                    Expanded(child: _SummaryPlaceholder()),
                    SizedBox(width: 10),
                    Expanded(child: _SummaryPlaceholder()),
                    SizedBox(width: 10),
                    Expanded(child: _SummaryPlaceholder()),
                  ],
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Segment control
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding, 18, AppSpacing.screenPadding, 0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.creamDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: List.generate(_segments.length, (index) {
                    final isActive = _selectedSegment == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedSegment = index);
                          final filter = index == 0
                              ? null
                              : index == 1
                                  ? 'pending'
                                  : 'cleared';
                          ref.read(chequeFilterProvider.notifier).state =
                              filter;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 36,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.surface
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              _segments[index],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Cheque list
            Expanded(
              child: cheques.when(
                data: (list) => list.isEmpty
                    ? const Center(
                        child: Text(
                          'No cheques found',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          16,
                          AppSpacing.screenPadding,
                          100,
                        ),
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final cheque = list[index];
                          return ChequeListTile(
                            cheque: cheque,
                            onTap: () => context.push(
                              '/tenant/cheques/${cheque.id}',
                            ),
                          );
                        },
                      ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 16),
                      Text(
                        err.toString(),
                        style: const TextStyle(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(chequeListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryPlaceholder extends StatelessWidget {
  const _SummaryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    );
  }
}
