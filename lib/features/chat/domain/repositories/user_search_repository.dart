import 'package:dartz/dartz.dart';
import '../entities/user_search_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class UserSearchRepository {
  Future<Either<Failure, List<UserSearchEntity>>> searchUsers(String query);
  Future<Either<Failure, List<UserSearchEntity>>> getRecentUsers();
} 