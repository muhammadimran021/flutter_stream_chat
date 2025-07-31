import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    required String username,
  });
  
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
  });
  
  Future<Either<Failure, void>> signOut();
  
  Future<Either<Failure, User?>> getCurrentUser();
  
  Future<Either<Failure, void>> saveUser(User user);
  
  Future<Either<Failure, void>> clearUserData();
} 