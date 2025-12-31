import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String status;
  final int interviews;
  final DateTime updatedAt;
  final bool isSelected;
  final bool isActive;

  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.interviews,
    required this.updatedAt,
    this.isSelected = false,
    required this.isActive
  });

  Project copyWith({
    String? id,
    String? name,
    String? status,
    int? interviews,
    DateTime? updatedAt,
    bool? isSelected,
    bool? isActive
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      interviews: interviews ?? this.interviews,
      updatedAt: updatedAt ?? this.updatedAt,
      isSelected: isSelected ?? this.isSelected,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, status, interviews, updatedAt, isSelected, isActive];
}
