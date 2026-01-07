import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/interviews/domain/entities/interview.dart';
import 'package:booster/features/interviews/presentation/widgets/interview_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Interview Card Widget
/// Displays an interview in a card format
class InterviewCard extends StatelessWidget {
  final Interview interview;
  final VoidCallback? onTap;

  const InterviewCard({
    super.key,
    required this.interview,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Interview Type Icon
                  Row(
                    children: [
                      Icon(
                        interview.interviewType == InterviewType.visita
                            ? Icons.home
                            : Icons.person,
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: AppSpacing.xs.w),
                      Text(
                        interview.interviewType == InterviewType.visita
                            ? 'VISITA'
                            : 'CLIENTE',
                        style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  // Status Badge
                  InterviewStatusBadge(status: interview.status),
                ],
              ),

              SizedBox(height: AppSpacing.sm.h),

              // Duration and Date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: AppColors.textPrimaryLight,
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Text(
                    interview.formattedDuration,
                    style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Icon(
                    Icons.calendar_today,
                    size: 14.sp,
                    color: AppColors.textPrimaryLight,
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Text(
                    _formatDate(interview.createdAt),
                    style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),

              // Processing provider if available
              if (interview.providerUsed != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      size: 14.sp,
                      color: AppColors.textPrimaryLight,
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    Text(
                      'Procesado con ${interview.providerUsed!.value}',
                      style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimaryLight,
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],

              // Progress indicator for processing interviews
              if (interview.isProcessing) ...[
                SizedBox(height: AppSpacing.sm.h),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  'Procesando entrevista...',
                  style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días atrás';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
