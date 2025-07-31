import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'sign_in_usecase.dart';

class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;
  
  GetCurrentUserUseCase(this.repository);
  
  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

class NoParams {
  const NoParams();
} 