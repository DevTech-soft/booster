import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/core/widgets/outline_button.dart';
import 'package:booster/core/widgets/primary_button.dart';
import 'package:booster/features/projects/presentation/bloc/bloc.dart';
import 'package:booster/features/projects/presentation/pages/record_page.dart';
import 'package:booster/features/projects/presentation/widgets/action_bar.dart';
import 'package:booster/features/projects/presentation/widgets/projects_table.dart';
import 'package:booster/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProjectsBloc>()..add(const LoadProjects()),
      child: const _ProjectsPageContent(),
    );
  }
}

class _ProjectsPageContent extends StatelessWidget {
  const _ProjectsPageContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppHeader(
          showDecoration: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/svg/back.svg'),
          ),
          trailing: SvgPicture.asset(
            'assets/svg/profile_avatar.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingHorizontalXL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: AppSpacing.md.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomOutlineButton(
                      borderRadius: AppSpacing.radiusXXL.r,
                      width: 200.w,
                      isFullWidth: false,
                      icon: SvgPicture.asset('assets/svg/microphone.svg'),
                      text: 'INICIAR AUDIO',
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
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
                Divider(color: AppColors.primary, thickness: 2),
                SizedBox(height: AppSpacing.sm.h),
                Row(
                  children: [
                    Text(
                      'Proyectos',
                      style: AppTypography.lightTextTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.sp,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xxl.h),
                PrimaryButton(
                  width: 200.w,
                  isFullWidth: false,
                  text: 'Nuevo Proyecto',
                  icon: Icon(Icons.add, size: AppSpacing.iconMD),
                  onPressed: () {},
                ),
                SizedBox(height: AppSpacing.lg.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [ActionsBar()],
                ),

                // BlocBuilder<ProjectsBloc, ProjectsState>(
                //   builder: (context, state) {
                //     if (state is ProjectsLoaded && state.hasSelection) {
                //       return Column(
                //         children: [

                //           SizedBox(height: AppSpacing.md.h),
                //         ],
                //       );
                //     }
                //     return const SizedBox.shrink();
                //   },
                // ),

                // Projects Table
                BlocBuilder<ProjectsBloc, ProjectsState>(
                  builder: (context, state) {
                    if (state is ProjectsLoading) {
                      return _buildLoadingState();
                    } else if (state is ProjectsLoaded) {
                      return ProjectsTable(
                        projects: state.projects,
                        selectedProjectIds: state.selectedProjectIds,
                      );
                    } else if (state is ProjectsError) {
                      return _buildErrorState(context, state.message);
                    }
                    return const SizedBox.shrink();
                  },
                ),

                SizedBox(height: AppSpacing.xl.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Cargando proyectos...',
              style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xxl.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'Error al cargar proyectos',
            style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          PrimaryButton(
            width: 200,
            isFullWidth: false,
            text: 'Reintentar',
            onPressed: () {
              context.read<ProjectsBloc>().add(const LoadProjects());
            },
          ),
        ],
      ),
    );
  }
}
