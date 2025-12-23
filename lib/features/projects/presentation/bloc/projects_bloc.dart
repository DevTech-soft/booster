import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booster/core/usecases/usecase.dart';
import 'package:booster/features/projects/domain/usecases/get_projects.dart';
import 'package:booster/features/projects/presentation/bloc/projects_event.dart';
import 'package:booster/features/projects/presentation/bloc/projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjects getProjects;

  ProjectsBloc({
    required this.getProjects,
  }) : super(const ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<ToggleProjectSelection>(_onToggleProjectSelection);
    on<SelectAllProjects>(_onSelectAllProjects);
    on<DeselectAllProjects>(_onDeselectAllProjects);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());

    final result = await getProjects(const NoParams());

    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects: projects)),
    );
  }

  void _onToggleProjectSelection(
    ToggleProjectSelection event,
    Emitter<ProjectsState> emit,
  ) {
    if (state is ProjectsLoaded) {
      final currentState = state as ProjectsLoaded;
      final selectedIds = List<String>.from(currentState.selectedProjectIds);

      if (selectedIds.contains(event.projectId)) {
        selectedIds.remove(event.projectId);
      } else {
        selectedIds.add(event.projectId);
      }

      emit(currentState.copyWith(selectedProjectIds: selectedIds));
    }
  }

  void _onSelectAllProjects(
    SelectAllProjects event,
    Emitter<ProjectsState> emit,
  ) {
    if (state is ProjectsLoaded) {
      final currentState = state as ProjectsLoaded;
      final allProjectIds = currentState.projects.map((p) => p.id).toList();
      emit(currentState.copyWith(selectedProjectIds: allProjectIds));
    }
  }

  void _onDeselectAllProjects(
    DeselectAllProjects event,
    Emitter<ProjectsState> emit,
  ) {
    if (state is ProjectsLoaded) {
      final currentState = state as ProjectsLoaded;
      emit(currentState.copyWith(selectedProjectIds: []));
    }
  }
}
