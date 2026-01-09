import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/core/widgets/outline_button.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/projects/presentation/widgets/record_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RecordPage extends StatefulWidget {
  final String? projectId;
  final String? tenantId;
  final String? advisorId;
  final String? clientId;
  final String? audioType;
  final InterviewType? interviewType;

  const RecordPage({
    super.key,
    this.projectId,
    this.tenantId,
    this.advisorId,
    this.clientId,
    this.audioType,
    this.interviewType,
  });

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              showDecoration: false,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/svg/close.svg'),
              ),
            ),
            Text(
              'Comenzar grabación',
              style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppSpacing.verticalSpaceXL,
                    RecordStateWidget(
                      projectId: widget.projectId,
                      tenantId: widget.tenantId,
                      advisorId: widget.advisorId,
                      clientId: widget.clientId,
                      audioType: widget.audioType,
                      interviewType: widget.interviewType,
                    ),
                    AppSpacing.verticalSpaceXL,
                     CustomOutlineButton(
                      borderRadius: AppSpacing.radiusXXL.r,
                      width: 200.w,
                      isFullWidth: false,
                      text: 'Cargar Audio',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordPage(),
                          ),
                        );
                      },
                      textColor: AppColors.textBlack,
                      borderColor: AppColors.backgroundDark,
                    ),
                     AppSpacing.verticalSpaceMD,
                    CustomOutlineButton(
                      borderRadius: AppSpacing.radiusXXL.r,
                      width: 200.w,
                      isFullWidth: false,
                      text: 'Ver Audios',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordPage(),
                          ),
                        );
                      },
                      textColor: AppColors.primary,
                      borderColor: AppColors.primary,
                    ),
                   
                    
                    AppSpacing.verticalSpaceXL
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

