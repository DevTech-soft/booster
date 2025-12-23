import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String status;
  final int interviews;
  final DateTime updatedAt;
  final bool isSelected;

  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.interviews,
    required this.updatedAt,
    this.isSelected = false,
  });

  Project copyWith({
    String? id,
    String? name,
    String? status,
    int? interviews,
    DateTime? updatedAt,
    bool? isSelected,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      interviews: interviews ?? this.interviews,
      updatedAt: updatedAt ?? this.updatedAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, name, status, interviews, updatedAt, isSelected];
}
