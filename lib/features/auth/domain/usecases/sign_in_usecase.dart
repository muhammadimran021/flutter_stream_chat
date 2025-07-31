import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<User, SignInParams> {
  final AuthRepository repository;
  
  SignInUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signIn(
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;
  final String username;
  
  const SignInParams({
    required this.email,
    required this.password,
    required this.username,
  });
  
  @override
  List<Object> get props => [email, password, username];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
} 