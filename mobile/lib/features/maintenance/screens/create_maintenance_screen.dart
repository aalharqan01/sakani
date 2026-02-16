import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/maintenance_providers.dart';
import '../repositories/maintenance_repository.dart';

class CreateMaintenanceScreen extends ConsumerStatefulWidget {
  final String? preselectedCategory;

  const CreateMaintenanceScreen({super.key, this.preselectedCategory});

  @override
  ConsumerState<CreateMaintenanceScreen> createState() =>
      _CreateMaintenanceScreenState();
}

class _CreateMaintenanceScreenState
    extends ConsumerState<CreateMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedUrgency = 'routine';
  String? _selectedCategoryId;
  DateTime? _preferredDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.preselectedCategory;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _preferredDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(maintenanceRepositoryProvider);
      await repo.createRequest(
        unitId: '', // Will be filled from user's active lease/unit
        categoryId: _selectedCategoryId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        urgency: _selectedUrgency,
        preferredDate1: _preferredDate,
      );

      // Refresh the list
      ref.invalidate(maintenanceRequestsProvider);

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.requestSubmitted),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHero(l10n),
          Expanded(child: _buildForm(l10n, categoriesAsync)),
        ],
      ),
    );
  }

  Widget _buildHero(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56, left: 28, right: 28, bottom: 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyLight, Color(0xFF4338CA)],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.newMaintenanceRequest,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.submitRequest,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n, AsyncValue categoriesAsync) {
    return Container(
      width: double.infinity,
      transform: Matrix4.translationValues(0, -20, 0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusSheet),
          topRight: Radius.circular(AppSpacing.radiusSheet),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 28, 24,
            MediaQuery.of(context).padding.bottom + 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category selector
              _FieldLabel(text: l10n.selectCategory),
              const SizedBox(height: 8),
              categoriesAsync.when(
                data: (categories) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map<Widget>((cat) {
                      final isSelected = _selectedCategoryId == cat.id;
                      return GestureDetector(
                        onTap: _isSubmitting
                            ? null
                            : () => setState(
                                () => _selectedCategoryId = cat.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.navy
                                : AppColors.cream,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.navy
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            cat.nameEn,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, __) => Text(
                  l10n.somethingWentWrong,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              _FieldLabel(text: l10n.titleLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                enabled: !_isSubmitting,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.short_text_rounded, size: 20),
                  hintText: l10n.titleHint,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.titleRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description
              _FieldLabel(text: l10n.description),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                enabled: !_isSubmitting,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.descriptionHint,
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.descriptionRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Urgency
              _FieldLabel(text: l10n.urgencyLevel),
              const SizedBox(height: 8),
              Row(
                children: [
                  _UrgencyChip(
                    label: l10n.urgencyRoutine,
                    value: 'routine',
                    selected: _selectedUrgency,
                    color: AppColors.urgencyRoutine,
                    enabled: !_isSubmitting,
                    onTap: () =>
                        setState(() => _selectedUrgency = 'routine'),
                  ),
                  const SizedBox(width: 8),
                  _UrgencyChip(
                    label: l10n.urgencyUrgent,
                    value: 'urgent',
                    selected: _selectedUrgency,
                    color: AppColors.urgencyUrgent,
                    enabled: !_isSubmitting,
                    onTap: () =>
                        setState(() => _selectedUrgency = 'urgent'),
                  ),
                  const SizedBox(width: 8),
                  _UrgencyChip(
                    label: l10n.urgencyEmergency,
                    value: 'emergency',
                    selected: _selectedUrgency,
                    color: AppColors.urgencyEmergency,
                    enabled: !_isSubmitting,
                    onTap: () =>
                        setState(() => _selectedUrgency = 'emergency'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Preferred date
              _FieldLabel(
                text: '${l10n.preferredDate} (${l10n.optional})',
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _isSubmitting ? null : _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusInput),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 12),
                      Text(
                        _preferredDate != null
                            ? DateFormat('MMM dd, yyyy')
                                .format(_preferredDate!)
                            : l10n.selectDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: _preferredDate != null
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Submit button
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusButton),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.submitRequest,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.send_rounded, size: 18),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _UrgencyChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _UrgencyChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : AppColors.cream,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
