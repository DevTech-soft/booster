import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class Interview extends Equatable {
  final String id;
  final String tenantId;
  final String clientId;
  final String proyectId;
  final String advisorId;
 final String interviewType;
 final String s3AudioKey;

  const Interview({
    required this.id,
    required this.tenantId,
    required this.clientId,
    required this.proyectId,
    required this.advisorId,
    required this.interviewType,
    required this.s3AudioKey,
    
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        clientId,
        proyectId,
        advisorId,
        interviewType, 
        s3AudioKey,
      ];
}