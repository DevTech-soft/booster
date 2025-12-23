import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final VoidCallback? onBack;
  final bool showDecoration;

  const AppHeader({super.key, this.leading, this.trailing, this.title, this.onBack, this.showDecoration = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg.h,
        bottom: AppSpacing.lg.h,
      ),
      decoration: showDecoration ? BoxDecoration(
        color: AppColors.textPrimaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusXXL.r * 2),
          bottomRight: Radius.circular(AppSpacing.radiusXXL.r * 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ) : null,
      
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(offset: Offset(0, 20.h), child: title ?? _buildLogo()),

          if (leading != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: AppSpacing.xl.w, bottom: AppSpacing.lg.h),
                child: leading!,
              ),
            ),

          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: AppSpacing.lg.w, bottom: AppSpacing.lg.h),
                child: trailing!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/LOGO_ISOTIPO_NEGATIVO.png',
      width: 80.w,
      height: 80.h,
      fit: BoxFit.contain,
    );
  }

  
}
