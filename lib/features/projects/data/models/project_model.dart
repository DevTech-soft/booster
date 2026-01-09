import 'package:booster/features/projects/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.tenantId,
    required super.name,
    required super.status,
    required super.interviews,
    required super.updatedAt,
    super.isSelected,
    required super.isActive,
  });

  /// Mapea desde la respuesta de la API
  /// La API devuelve: id, tenant_id, name, code, description, is_active, created_at, updated_at
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Mapear is_active a status
    final isActive = json['is_active'] as bool? ?? true;
    final status = isActive ? 'Abierto' : 'Cerrado';
    final interviews = json['interviews'] as int? ?? 0;

    return ProjectModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      name: json['name'] as String,
      status: status,
      interviews: interviews,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isSelected: json['isSelected'] as bool? ?? false,
      isActive: json['is_active'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'name': name,
      'status': status,
      'interviews': interviews,
      'updatedAt': updatedAt.toIso8601String(),
      'isSelected': isSelected,
      'is_active' : isActive,
    };
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      tenantId: project.tenantId,
      name: project.name,
      status: project.status,
      interviews: project.interviews,
      updatedAt: project.updatedAt,
      isSelected: project.isSelected,
      isActive: project.isActive,
    );
  }
}
