import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userModel = await remoteDataSource.signIn(
        email: email,
        password: password,
        username: username,
      );
      
      // Save user data locally
      await localDataSource.saveUser(userModel);
      if (userModel.streamToken != null) {
        await localDataSource.saveStreamToken(userModel.streamToken!);
      }
      
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userModel = await remoteDataSource.signUp(
        email: email,
        password: password,
        username: username,
      );
      
      // Save user data locally
      await localDataSource.saveUser(userModel);
      if (userModel.streamToken != null) {
        await localDataSource.saveStreamToken(userModel.streamToken!);
      }
      
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await localDataSource.saveUser(userModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> clearUserData() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
} 