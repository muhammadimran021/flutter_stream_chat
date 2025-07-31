import 'package:equatable/equatable.dart';
import '../../domain/entities/user_search_entity.dart';

abstract class UserSearchState extends Equatable {
  const UserSearchState();

  @override
  List<Object?> get props => [];
}

class UserSearchInitial extends UserSearchState {}

class UserSearchLoading extends UserSearchState {}

class UserSearchLoaded extends UserSearchState {
  final List<UserSearchEntity> users;
  final String? query;

  const UserSearchLoaded({
    required this.users,
    this.query,
  });

  @override
  List<Object?> get props => [users, query];

  UserSearchLoaded copyWith({
    List<UserSearchEntity>? users,
    String? query,
  }) {
    return UserSearchLoaded(
      users: users ?? this.users,
      query: query ?? this.query,
    );
  }
}

class UserSearchError extends UserSearchState {
  final String message;

  const UserSearchError({required this.message});

  @override
  List<Object?> get props => [message];
} 