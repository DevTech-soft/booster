import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Outline button widget for secondary actions
///
/// Features:
/// - Border style with transparent background
/// - Loading state support
/// - Disabled state support
/// - Responsive sizing
/// - Optional icon support
class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;

  const CustomOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height,
    this.icon,
    this.borderColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      // height: height ?? AppSpacing.buttonHeightLG.h,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.textPrimaryLight,
          disabledForegroundColor: AppColors.textDisabledLight,
          side: BorderSide(
            color: isDisabled
                ? AppColors.textDisabledLight
                : (borderColor ?? AppColors.textSecondaryLight),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular( borderRadius ?? AppSpacing.radiusSM.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.xs.h,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    AppSpacing.horizontalSpaceSM,
                  ],
                  Text(
                    text,
                    style: AppTypography.buttonMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
