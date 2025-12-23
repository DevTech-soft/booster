import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ConfirmResetPassword implements UseCase<Either<Failure, void>, ConfirmResetPasswordParams> {
  final AuthRepository repository;

  ConfirmResetPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ConfirmResetPasswordParams params) async {
    return await repository.confirmResetPassword(
      email: params.email,
      code: params.code,
      newPassword: params.newPassword,
    );
  }
}

class ConfirmResetPasswordParams {
  final String email;
  final String code;
  final String newPassword;

  const ConfirmResetPasswordParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });
}
