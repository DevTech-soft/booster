import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/interviews/presentation/bloc/bloc.dart';
import 'package:booster/features/interviews/presentation/pages/interview_detail_page.dart';
import 'package:booster/features/interviews/presentation/widgets/empty_interviews_widget.dart';
import 'package:booster/features/interviews/presentation/widgets/interview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Interviews List Page
/// Displays list of interviews for a specific project
class InterviewsListPage extends StatelessWidget {
  final String projectId;
  final String projectName;
  final String tenantId;

  const InterviewsListPage({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.tenantId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              showDecoration: false,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/svg/back.svg'),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entrevistas',
                    style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    projectName,
                    style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.md.h),

            // Filters
            _buildFilters(context),

            SizedBox(height: AppSpacing.sm.h),

            // Interviews List
            Expanded(
              child: BlocBuilder<InterviewsBloc, InterviewsState>(
                builder: (context, state) {
                  if (state is InterviewsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is InterviewsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            Text(
                              'Error',
                              style: AppTypography.lightTextTheme.titleLarge?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm.h),
                            Text(
                              state.message,
                              style: AppTypography.lightTextTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<InterviewsBloc>().add(
                                      LoadInterviews(
                                        projectId: projectId,
                                        tenantId: tenantId,
                                      ),
                                    );
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is InterviewsEmpty) {
                    return EmptyInterviewsWidget(
                      hasFilters: state.filters.hasActiveFilters,
                      onClearFilters: state.filters.hasActiveFilters
                          ? () => context.read<InterviewsBloc>().add(const ClearFilters())
                          : null,
                    );
                  }

                  if (state is InterviewsLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<InterviewsBloc>().add(const RefreshInterviews());
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                        itemCount: state.interviews.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Load more indicator
                          if (index == state.interviews.length) {
                            if (!state.isLoadingMore) {
                              // Trigger load more
                              Future.microtask(() {
                                context.read<InterviewsBloc>().add(const LoadMoreInterviews());
                              });
                            }
                            return Padding(
                              padding: EdgeInsets.all(AppSpacing.lg.w),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final interview = state.interviews[index];
                          return InterviewCard(
                            interview: interview,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InterviewDetailPage(
                                    interviewId: interview.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<InterviewsBloc, InterviewsState>(
              builder: (context, state) {
                if (state is! InterviewsLoaded && state is! InterviewsEmpty) {
                  return const SizedBox.shrink();
                }

                final filters = state is InterviewsLoaded
                    ? state.filters
                    : (state as InterviewsEmpty).filters;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Type Filter
                      _FilterChip(
                        label: 'Tipo',
                        isActive: filters.interviewType != null,
                        activeLabel: filters.interviewType?.value,
                        onTap: () => _showTypeFilterDialog(context, filters.interviewType),
                      ),
                      SizedBox(width: AppSpacing.sm.w),

                      // Status Filter
                      _FilterChip(
                        label: 'Estado',
                        isActive: filters.status != null,
                        activeLabel: filters.status?.value,
                        onTap: () => _showStatusFilterDialog(context, filters.status),
                      ),
                      SizedBox(width: AppSpacing.sm.w),

                      // Clear Filters
                      if (filters.hasActiveFilters)
                        TextButton(
                          onPressed: () {
                            context.read<InterviewsBloc>().add(const ClearFilters());
                          },
                          child: Text(
                            'Limpiar',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTypeFilterDialog(BuildContext context, InterviewType? currentType) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filtrar por tipo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Todos'),
              leading: Radio<InterviewType?>(
                value: null,
                groupValue: currentType,
                onChanged: (value) {
                  context.read<InterviewsBloc>().add(FilterByType(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('VISITA'),
              leading: Radio<InterviewType?>(
                value: InterviewType.visita,
                groupValue: currentType,
                onChanged: (value) {
                  context.read<InterviewsBloc>().add(FilterByType(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ListTile(
              title: const Text('CLIENTE'),
              leading: Radio<InterviewType?>(
                value: InterviewType.cliente,
                groupValue: currentType,
                onChanged: (value) {
                  context.read<InterviewsBloc>().add(FilterByType(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusFilterDialog(BuildContext context, InterviewStatus? currentStatus) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filtrar por estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Todos'),
              leading: Radio<InterviewStatus?>(
                value: null,
                groupValue: currentStatus,
                onChanged: (value) {
                  context.read<InterviewsBloc>().add(FilterByStatus(value));
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            ...InterviewStatus.values.map((status) {
              return ListTile(
                title: Text(status.value),
                leading: Radio<InterviewStatus?>(
                  value: status,
                  groupValue: currentStatus,
                  onChanged: (value) {
                    context.read<InterviewsBloc>().add(FilterByStatus(value));
                    Navigator.pop(dialogContext);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final String? activeLabel;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    this.activeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXXL.r),
        ),
        child: Row(
          children: [
            Text(
              isActive && activeLabel != null ? activeLabel! : label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textBlack,
                fontSize: 13.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            SizedBox(width: AppSpacing.xs.w),
            Icon(
              isActive ? Icons.check : Icons.arrow_drop_down,
              size: 18.sp,
              color: isActive ? Colors.white : AppColors.textBlack,
            ),
          ],
        ),
      ),
    );
  }
}
