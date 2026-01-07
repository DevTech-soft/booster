import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Empty Interviews Widget
/// Displayed when there are no interviews to show
class EmptyInterviewsWidget extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback? onClearFilters;

  const EmptyInterviewsWidget({
    super.key,
    this.hasFilters = false,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.mic_none,
              size: 80.sp,
              color: AppColors.textPrimaryLight.withOpacity(0.3),
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              hasFilters
                  ? 'No se encontraron entrevistas'
                  : 'No hay entrevistas aún',
              style: AppTypography.lightTextTheme.titleMedium?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              hasFilters
                  ? 'Intenta ajustar los filtros para ver más resultados'
                  : 'Comienza grabando una nueva entrevista',
              style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters && onClearFilters != null) ...[
              SizedBox(height: AppSpacing.lg.h),
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  'Limpiar filtros',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
