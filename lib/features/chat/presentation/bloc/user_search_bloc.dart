import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../../../core/errors/failures.dart';
import 'user_search_event.dart';
import 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchUsersUseCase searchUsersUseCase;

  UserSearchBloc({required this.searchUsersUseCase}) : super(UserSearchInitial()) {
    on<SearchUsers>(_onSearchUsers);
    on<ClearSearch>(_onClearSearch);
    on<LoadRecentUsers>(_onLoadRecentUsers);
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserSearchState> emit,
  ) async {
    if (event.query.length < 2) {
      emit(UserSearchLoaded(users: [], query: event.query));
      return;
    }

    emit(UserSearchLoading());

    final result = await searchUsersUseCase(SearchUsersParams(query: event.query));

    result.fold(
      (failure) => emit(UserSearchError(message: _mapFailureToMessage(failure))),
      (users) => emit(UserSearchLoaded(users: users, query: event.query)),
    );
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<UserSearchState> emit,
  ) async {
    emit(UserSearchInitial());
  }

  Future<void> _onLoadRecentUsers(
    LoadRecentUsers event,
    Emitter<UserSearchState> emit,
  ) async {
    emit(UserSearchLoading());

    // For now, we'll use a simple search to get recent users
    // In a real app, you might want a separate use case for this
    final result = await searchUsersUseCase(const SearchUsersParams(query: ''));

    result.fold(
      (failure) => emit(UserSearchError(message: _mapFailureToMessage(failure))),
      (users) => emit(UserSearchLoaded(users: users, query: null)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Network error: ${failure.message}';
    } else if (failure is AuthFailure) {
      return 'Authentication error: ${failure.message}';
    } else {
      return 'Unexpected error: ${failure.message}';
    }
  }
} 