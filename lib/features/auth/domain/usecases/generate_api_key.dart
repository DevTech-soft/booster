import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/api_key_response.dart';
import '../repositories/api_key_repository.dart';

class GenerateApiKey implements UseCase<Either<Failure, ApiKeyResponse>, GenerateApiKeyParams> {
  final ApiKeyRepository repository;

  GenerateApiKey(this.repository);

  @override
  Future<Either<Failure, ApiKeyResponse>> call(GenerateApiKeyParams params) async {
    return await repository.generateAndSaveApiKey(
      userId: params.userId,
      name: params.name,
      expiresInDays: params.expiresInDays,
    );
  }
}

class GenerateApiKeyParams {
  final String userId;
  final String name;
  final int expiresInDays;

  const GenerateApiKeyParams({
    required this.userId,
    this.name = 'Mobile App Key',
    this.expiresInDays = 90,
  });
}
