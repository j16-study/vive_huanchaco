// vive_huanchaco/lib/features/auth/domain/usecases/logout_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:vive_huanchaco/core/error/failures.dart';
import 'package:vive_huanchaco/core/usecases/usecase.dart';
import 'package:vive_huanchaco/domain/auth/repositories/auth_repository.dart';

class LogoutUserUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logoutUser();
  }
}