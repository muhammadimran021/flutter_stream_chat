import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/user_search_entity.dart';
import '../repositories/user_search_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SearchUsersUseCase implements UseCase<List<UserSearchEntity>, SearchUsersParams> {
  final UserSearchRepository repository;

  SearchUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserSearchEntity>>> call(SearchUsersParams params) async {
    return await repository.searchUsers(params.query);
  }
}

class SearchUsersParams extends Equatable {
  final String query;

  const SearchUsersParams({required this.query});

  @override
  List<Object?> get props => [query];
} 