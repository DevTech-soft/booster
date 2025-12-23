import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectsEvent {
  const LoadProjects();
}

class ToggleProjectSelection extends ProjectsEvent {
  final String projectId;

  const ToggleProjectSelection(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class SelectAllProjects extends ProjectsEvent {
  const SelectAllProjects();
}

class DeselectAllProjects extends ProjectsEvent {
  const DeselectAllProjects();
}
