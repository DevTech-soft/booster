import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/core/widgets/app_header.dart';
import 'package:booster/features/interviews/domain/constants/interview_constants.dart';
import 'package:booster/features/interviews/presentation/bloc/bloc.dart';
import 'package:booster/features/interviews/presentation/widgets/interview_status_badge.dart';
import 'package:booster/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

/// Interview Detail Page
/// Displays detailed information about an interview
class InterviewDetailPage extends StatelessWidget {
  final String interviewId;

  const InterviewDetailPage({
    super.key,
    required this.interviewId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InterviewDetailBloc>()
        ..add(LoadInterviewDetail(interviewId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<InterviewDetailBloc, InterviewDetailState>(
            listener: (context, state) {
              if (state is InterviewDetailDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Entrevista eliminada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true); // Return true to indicate deletion
              }

              if (state is InterviewDetailError && state.interview == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is InterviewDetailInitial || state is InterviewDetailLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is InterviewDetailError && state.interview == null) {
                return Column(
                  children: [
                    AppHeader(
                      showDecoration: false,
                      leading: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/svg/back.svg'),
                      ),
                    ),
                    Expanded(
                      child: Center(
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
                                  context.read<InterviewDetailBloc>().add(
                                        const RefreshInterviewDetail(),
                                      );
                                },
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final interview = state is InterviewDetailLoaded
                  ? state.interview
                  : state is InterviewDetailDeleting
                      ? state.interview
                      : (state as InterviewDetailError).interview!;

              final isDeleting = state is InterviewDetailDeleting;

              return Column(
                children: [
                  // Header
                  AppHeader(
                    showDecoration: false,
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset('assets/svg/back.svg'),
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmation(context);
                        } else if (value == 'refresh') {
                          context.read<InterviewDetailBloc>().add(
                                const RefreshInterviewDetail(),
                              );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'refresh',
                          child: Row(
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(width: 8),
                              Text('Actualizar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<InterviewDetailBloc>().add(
                              const RefreshInterviewDetail(),
                            );
                      },
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(AppSpacing.lg.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              'Detalle de Entrevista',
                              style: AppTypography.lightTextTheme.headlineSmall?.copyWith(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),

                            SizedBox(height: AppSpacing.lg.h),

                            // Type and Status Card
                            _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            interview.interviewType == InterviewType.visita
                                                ? Icons.home
                                                : Icons.person,
                                            size: 24.sp,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(width: AppSpacing.sm.w),
                                          Text(
                                            interview.interviewType == InterviewType.visita
                                                ? 'VISITA'
                                                : 'CLIENTE',
                                            style: AppTypography.lightTextTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      InterviewStatusBadge(status: interview.status),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: AppSpacing.md.h),

                            // Timeline Card
                            _buildCard(
                              title: 'Línea de Tiempo del Procesamiento',
                              child: _buildTimeline(interview.status),
                            ),

                            SizedBox(height: AppSpacing.md.h),

                            // Information Card
                            _buildCard(
                              title: 'Información',
                              child: Column(
                                children: [
                                  _buildInfoRow('Duración', interview.formattedDuration),
                                  _buildInfoRow('Idioma', interview.languageCode),
                                  if (interview.providerUsed != null)
                                    _buildInfoRow('Proveedor', interview.providerUsed!.value),
                                  _buildInfoRow(
                                    'Creado',
                                    _formatDateTime(interview.createdAt),
                                  ),
                                  _buildInfoRow(
                                    'Actualizado',
                                    _formatDateTime(interview.updatedAt),
                                  ),
                                  if (interview.startedAt != null)
                                    _buildInfoRow(
                                      'Inicio',
                                      _formatDateTime(interview.startedAt!),
                                    ),
                                  if (interview.endedAt != null)
                                    _buildInfoRow(
                                      'Fin',
                                      _formatDateTime(interview.endedAt!),
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(height: AppSpacing.md.h),

                            // Audio File Card
                            _buildCard(
                              title: 'Archivo de Audio',
                              child: SelectableText(
                                interview.s3AudioKey,
                                style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                                  color: AppColors.textPrimaryLight,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),

                            SizedBox(height: AppSpacing.md.h),

                            // IDs Card (for debugging/support)
                            _buildCard(
                              title: 'Identificadores',
                              child: Column(
                                children: [
                                  _buildInfoRow('Interview ID', interview.id, monospace: true),
                                  _buildInfoRow('Tenant ID', interview.tenantId, monospace: true),
                                  _buildInfoRow('Project ID', interview.projectId, monospace: true),
                                  _buildInfoRow('Advisor ID', interview.advisorId, monospace: true),
                                ],
                              ),
                            ),

                            if (isDeleting) ...[
                              SizedBox(height: AppSpacing.lg.h),
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(height: AppSpacing.sm.h),
                              Center(
                                child: Text(
                                  'Eliminando entrevista...',
                                  style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: AppTypography.lightTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
            ],
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool monospace = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.textBlack,
                fontFamily: monospace ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(InterviewStatus currentStatus) {
    final statuses = [
      InterviewStatus.received,
      InterviewStatus.transcribed,
      InterviewStatus.embedded,
      InterviewStatus.indexed,
    ];

    final currentIndex = statuses.indexOf(currentStatus);
    final isFailed = currentStatus == InterviewStatus.failed;

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex && !isFailed;
        final isCurrent = index == currentIndex && !isFailed;

        return Row(
          children: [
            // Icon
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                size: 16.sp,
                color: isCompleted ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),

            // Label
            Expanded(
              child: Text(
                status.value,
                style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  color: isCompleted ? AppColors.textBlack : AppColors.textPrimaryLight,
                ),
              ),
            ),

            if (isCurrent)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
                ),
                child: Text(
                  'Actual',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Entrevista'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta entrevista? '
          'Esta acción no se puede deshacer y eliminará todos los segmentos asociados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<InterviewDetailBloc>().add(
                    DeleteInterviewEvent(interviewId),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
