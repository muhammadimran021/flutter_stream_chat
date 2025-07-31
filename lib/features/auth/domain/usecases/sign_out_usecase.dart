import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import 'get_current_user_usecase.dart';

class SignOutUseCase {
  final AuthRepository repository;
  
  SignOutUseCase(this.repository);
  
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
} 