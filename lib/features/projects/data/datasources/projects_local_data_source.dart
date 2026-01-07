import 'package:booster/features/projects/data/models/project_model.dart';

abstract class ProjectsLocalDataSource {
  Future<List<ProjectModel>> getProjects();
}

class ProjectsLocalDataSourceImpl implements ProjectsLocalDataSource {
  @override
  Future<List<ProjectModel>> getProjects() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Hardcoded data based on the table image
    return [
      ProjectModel(
        id: '1',
        tenantId: 'tenant-001',
        name: 'MANGA HAUS 1',
        status: 'Abierto',
        interviews: 125,
        updatedAt: DateTime(2023, 6, 9),
        isSelected: false,
        isActive: true
      ),
      ProjectModel(
        id: '2',
        tenantId: 'tenant-001',
        name: 'MANGA HAUS 2',
        status: 'Abierto',
        interviews: 75,
        updatedAt: DateTime(2023, 8, 26),
        isSelected: true,
        isActive: true,
      ),
      ProjectModel(
        id: '3',
        tenantId: 'tenant-001',
        name: 'MUV',
        status: 'Abierto',
        interviews: 25,
        updatedAt: DateTime(2024, 1, 12),
        isSelected: false,
        isActive: true,
      ),
      ProjectModel(
        id: '4',
        tenantId: 'tenant-001',
        name: 'WOW',
        status: 'Abierto',
        interviews: 500,
        updatedAt: DateTime(2024, 3, 3),
        isSelected: false,
        isActive: true,
      ),
      ProjectModel(
        id: '5',
        tenantId: 'tenant-001',
        name: 'FELICITI',
        status: 'Abierto',
        interviews: 275,
        updatedAt: DateTime(2024, 3, 12),
        isSelected: false,
        isActive: true,
      ),
    ];
  }
}
