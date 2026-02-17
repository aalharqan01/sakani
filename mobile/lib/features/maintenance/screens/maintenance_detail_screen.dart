import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/maintenance_request_model.dart';
import '../providers/maintenance_providers.dart';
import '../repositories/maintenance_repository.dart';

class MaintenanceDetailScreen extends ConsumerWidget {
  final String requestId;
  const MaintenanceDetailScreen({required this.requestId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(maintenanceDetailProvider(requestId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: detailAsync.when(
        data: (request) =>
            _DetailContent(request: request, requestId: requestId),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(err.toString()),
              TextButton(
                onPressed: () =>
                    ref.invalidate(maintenanceDetailProvider(requestId)),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  final MaintenanceRequestModel request;
  final String requestId;
  const _DetailContent({required this.request, required this.requestId});

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  bool _isActioning = false;
  final _commentController = TextEditingController();

  MaintenanceRequestModel get request => widget.request;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back,
                          size: 24, color: AppColors.navy),
                      const SizedBox(width: 8),
                      Text(
                        l10n.maintenanceDetail,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildStatusHero(context),
                  const SizedBox(height: 24),
                  _buildInfoCard(context),
                  const SizedBox(height: 24),
                  _buildActions(context),
                  const SizedBox(height: 24),
                  _buildCommentsSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHero(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusLabel = _statusLabel(l10n, request.status);
    final urgencyLabel = _urgencyLabel(l10n, request.urgency);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _statusBgColor(request.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _statusColor(request.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(request.status),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            request.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${request.referenceNumber} \u00B7 $urgencyLabel',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat('MMM dd, yyyy').format(request.createdAt);

    final rows = <(String, String)>[
      (l10n.submittedOn, dateStr),
      if (request.categoryName != null)
        (l10n.category, request.categoryName!),
      (l10n.urgency, _urgencyLabel(l10n, request.urgency)),
      (l10n.status, _statusLabel(l10n, request.status)),
      if (request.unitNumber != null)
        (l10n.property, request.unitNumber!),
      if (request.compoundName != null)
        (l10n.compound, request.compoundName!),
      if (request.scheduledDate != null)
        (l10n.scheduledFor,
            DateFormat('MMM dd, yyyy').format(request.scheduledDate!)),
      if (request.completedAt != null)
        (l10n.completedOn,
            DateFormat('MMM dd, yyyy').format(request.completedAt!)),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rows.asMap().entries.map((entry) {
            final isLast = entry.key == rows.length - 1 &&
                request.description == null;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.borderLight),
                      ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.value.$1,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      entry.value.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (request.description != null && request.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                request.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(maintenanceRepositoryProvider);
    final status = request.status;

    // Completed but not rated — show rate button
    if (status == 'completed' && request.rating == null) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rateService,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.rateServiceSubtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _RatingWidget(
              isLoading: _isActioning,
              onSubmit: (rating, comment) async {
                final messenger = ScaffoldMessenger.of(context);
                setState(() => _isActioning = true);
                try {
                  await repo.rateRequest(
                    request.id,
                    rating: rating,
                    comment: comment,
                  );
                  if (mounted) {
                    ref.invalidate(
                        maintenanceDetailProvider(widget.requestId));
                    ref.invalidate(maintenanceRequestsProvider);
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.ratingSubmitted),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isActioning = false);
                }
              },
            ),
          ],
        ),
      );
    }

    // Confirmed / rated — show rating
    if (status == 'confirmed' || request.rating != null) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.successSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < (request.rating ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                  color: AppColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              if (request.ratingComment != null &&
                  request.ratingComment!.isNotEmpty)
                Expanded(
                  child: Text(
                    request.ratingComment!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // No actions for cancelled/quote_rejected statuses
    if (status == 'cancelled' || status == 'quote_rejected') {
      return const SizedBox.shrink();
    }

    return const SizedBox.shrink();
  }

  Widget _buildCommentsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final commentsAsync = ref.watch(maintenanceCommentsProvider(request.id));

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.comments,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Comment input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: l10n.addComment,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusButton),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () async {
                  final text = _commentController.text.trim();
                  if (text.isEmpty) return;
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await ref
                        .read(maintenanceRepositoryProvider)
                        .addComment(request.id, text: text);
                    _commentController.clear();
                    ref.invalidate(
                        maintenanceCommentsProvider(request.id));
                  } catch (e) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.send, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Comments list
          commentsAsync.when(
            data: (comments) {
              if (comments.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      l10n.noComments,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: comments.map((comment) {
                  final date = comment['created_at'] != null
                      ? DateFormat('MMM dd, h:mm a')
                          .format(DateTime.parse(comment['created_at']))
                      : '';
                  final userName =
                      comment['user_name'] as String? ?? '';
                  final text = comment['text'] as String? ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text(err.toString()),
          ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'submitted':
        return l10n.statusSubmitted;
      case 'acknowledged':
        return l10n.statusAcknowledged;
      case 'quoted':
        return l10n.statusQuoted;
      case 'quote_accepted':
        return l10n.statusQuoteAccepted;
      case 'quote_rejected':
        return l10n.statusQuoteRejected;
      case 'scheduled':
        return l10n.statusScheduled;
      case 'in_progress':
        return l10n.statusInProgress;
      case 'completed':
        return l10n.statusCompleted;
      case 'confirmed':
        return l10n.statusConfirmed;
      case 'cancelled':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }

  String _urgencyLabel(AppLocalizations l10n, String urgency) {
    switch (urgency) {
      case 'routine':
        return l10n.urgencyRoutine;
      case 'urgent':
        return l10n.urgencyUrgent;
      case 'emergency':
        return l10n.urgencyEmergency;
      default:
        return urgency;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'submitted':
      case 'acknowledged':
        return AppColors.primaryDark;
      case 'quoted':
      case 'scheduled':
        return AppColors.warning;
      case 'quote_accepted':
      case 'in_progress':
        return AppColors.chequeDeposited;
      case 'completed':
      case 'confirmed':
        return AppColors.success;
      case 'quote_rejected':
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'submitted':
      case 'acknowledged':
        return AppColors.primarySurface;
      case 'quoted':
      case 'scheduled':
        return AppColors.warningSurface;
      case 'quote_accepted':
      case 'in_progress':
        return const Color(0xFFDBEAFE);
      case 'completed':
      case 'confirmed':
        return AppColors.successSurface;
      case 'quote_rejected':
      case 'cancelled':
        return AppColors.errorSurface;
      default:
        return AppColors.creamDark;
    }
  }
}

class _RatingWidget extends StatefulWidget {
  final bool isLoading;
  final Future<void> Function(int rating, String? comment) onSubmit;

  const _RatingWidget({
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<_RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<_RatingWidget> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: 36,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: l10n.ratingComment,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _rating == 0 || widget.isLoading
                  ? null
                  : () {
                      widget.onSubmit(
                        _rating,
                        _commentController.text.trim().isEmpty
                            ? null
                            : _commentController.text.trim(),
                      );
                    },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.submitRating),
            ),
          ),
        ],
      ),
    );
  }
}
