import 'package:equatable/equatable.dart';

abstract class UserSearchEvent extends Equatable {
  const UserSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchUsers extends UserSearchEvent {
  final String query;

  const SearchUsers({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends UserSearchEvent {}

class LoadRecentUsers extends UserSearchEvent {} 