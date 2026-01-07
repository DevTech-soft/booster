import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Interview Status Badge Widget
/// Displays the status of an interview with appropriate color
class InterviewStatusBadge extends StatelessWidget {
  final InterviewStatus status;
  final bool showIcon;

  const InterviewStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
        border: Border.all(
          color: config.color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              config.icon,
              size: 12.sp,
              color: config.color,
            ),
            SizedBox(width: AppSpacing.xs.w),
          ],
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.received:
        return _StatusConfig(
          label: 'RECIBIDO',
          color: Colors.grey,
          icon: Icons.upload_file,
        );
      case InterviewStatus.transcribed:
        return _StatusConfig(
          label: 'TRANSCRITO',
          color: Colors.blue,
          icon: Icons.text_fields,
        );
      case InterviewStatus.embedded:
        return _StatusConfig(
          label: 'PROCESANDO',
          color: Colors.orange,
          icon: Icons.sync,
        );
      case InterviewStatus.indexed:
        return _StatusConfig(
          label: 'COMPLETADO',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case InterviewStatus.failed:
        return _StatusConfig(
          label: 'FALLIDO',
          color: Colors.red,
          icon: Icons.error,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}
