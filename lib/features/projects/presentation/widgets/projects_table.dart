import 'package:booster/core/theme/app_colors.dart';
import 'package:booster/core/theme/app_spacing.dart';
import 'package:booster/core/theme/app_typography.dart';
import 'package:booster/features/projects/domain/entities/project.dart';
import 'package:booster/features/projects/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProjectsTable extends StatelessWidget {
  final List<Project> projects;
  final List<String> selectedProjectIds;

  const ProjectsTable({
    super.key,
    required this.projects,
    required this.selectedProjectIds,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 400.w),
        child: Container(
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
          child: Table(
            columnWidths: {
              0: FixedColumnWidth(32.w), 
              1: FixedColumnWidth(100.w), 
              2: FixedColumnWidth(70.w), 
              3: FixedColumnWidth(75.w),
              4: FixedColumnWidth(85.w), 
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildHeaderRow(),
              ...projects.map((project) {
                final isSelected = selectedProjectIds.contains(project.id);
                return _buildDataRow(context, project, isSelected);
              }),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: AppColors.textSecondaryLight.withValues(alpha: 0.15),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusMD.r),
          topRight: Radius.circular(AppSpacing.radiusMD.r),
        ),
      ),
      children: [
        const SizedBox(),
        _headerText('ESTUDIOS'),
        _headerText('ESTATUS', align: TextAlign.center),
        _headerText('ENTREVISTAS', align: TextAlign.center),
        _headerText('ACTUALIZADO', align: TextAlign.right),
      ],
    );
  }

  Widget _headerText(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  TableRow _buildDataRow(
    BuildContext context,
    Project project,
    bool isSelected,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondaryLight.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 32.w,
            height: 32.w,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              value: isSelected,
              activeColor: AppColors.primary,
              onChanged: (_) {
                context.read<ProjectsBloc>().add(
                  ToggleProjectSelection(project.id),
                );
              },
            ),
          ),
        ),

        _cellText(project.name, color: AppColors.primary, underline: true),

        _cellText(project.status, align: TextAlign.center),

        _cellText(project.interviews.toString(), align: TextAlign.center),

        _cellText(_formatDate(project.updatedAt), align: TextAlign.right),
      ],
    );
  }

  Widget _cellText(
    String text, {
    TextAlign align = TextAlign.left,
    Color? color,
    bool underline = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
          fontSize: 11.sp,
          height: 1.2, // reduce altura de línea
          color: color ?? AppColors.textBlack,
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxl.w),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 64.sp,
            color: AppColors.textDisabledLight,
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'No hay proyectos disponibles',
            style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('d-MMM-yy', 'es');
    return formatter.format(date);
  }
}
