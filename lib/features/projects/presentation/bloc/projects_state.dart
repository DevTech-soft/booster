import 'package:equatable/equatable.dart';
import 'package:booster/features/projects/domain/entities/project.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;
  final List<String> selectedProjectIds;

  const ProjectsLoaded({
    required this.projects,
    this.selectedProjectIds = const [],
  });

  bool isProjectSelected(String projectId) {
    return selectedProjectIds.contains(projectId);
  }

  int get selectedCount => selectedProjectIds.length;

  bool get hasSelection => selectedProjectIds.isNotEmpty;

  bool get allSelected => projects.length == selectedProjectIds.length;

  ProjectsLoaded copyWith({
    List<Project>? projects,
    List<String>? selectedProjectIds,
  }) {
    return ProjectsLoaded(
      projects: projects ?? this.projects,
      selectedProjectIds: selectedProjectIds ?? this.selectedProjectIds,
    );
  }

  @override
  List<Object?> get props => [projects, selectedProjectIds];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object?> get props => [message];
}
