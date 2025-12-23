import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyAndSetPassword implements UseCase<Either<Failure, User>, VerifyAndSetPasswordParams> {
  final AuthRepository repository;

  VerifyAndSetPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyAndSetPasswordParams params) async {
    return await repository.verifyAndSetPassword(
      email: params.email,
      verificationCode: params.verificationCode,
      temporaryPassword: params.temporaryPassword,
      newPassword: params.newPassword,
    );
  }
}

class VerifyAndSetPasswordParams {
  final String email;
  final String verificationCode;
  final String temporaryPassword;
  final String newPassword;

  const VerifyAndSetPasswordParams({
    required this.email,
    required this.verificationCode,
    required this.temporaryPassword,
    required this.newPassword,
  });
}
