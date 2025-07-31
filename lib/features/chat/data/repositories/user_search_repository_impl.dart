import 'package:dartz/dartz.dart';
import '../../domain/entities/user_search_entity.dart';
import '../../domain/repositories/user_search_repository.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/user_search_remote_data_source.dart';

class UserSearchRepositoryImpl implements UserSearchRepository {
  final UserSearchRemoteDataSource remoteDataSource;

  UserSearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserSearchEntity>>> searchUsers(String query) async {
    try {
      final users = await remoteDataSource.searchUsers(query);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserSearchEntity>>> getRecentUsers() async {
    try {
      final users = await remoteDataSource.getRecentUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
} 