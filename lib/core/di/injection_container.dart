import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/chat/data/datasources/user_search_remote_data_source.dart';
import '../../features/chat/data/repositories/user_search_repository_impl.dart';
import '../../features/chat/domain/repositories/user_search_repository.dart';
import '../../features/chat/domain/usecases/search_users_usecase.dart';
import '../../features/chat/presentation/bloc/user_search_bloc.dart';
import '../../features/chat/presentation/cubit/navigation_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Chat Feature - Bloc
  sl.registerFactory(
    () => UserSearchBloc(
      searchUsersUseCase: sl(),
    ),
  );

  // Chat Feature - Cubit
  sl.registerFactory(() => NavigationCubit());

  // Chat Feature - Use cases
  sl.registerLazySingleton(() => SearchUsersUseCase(sl()));

  // Chat Feature - Repository
  sl.registerLazySingleton<UserSearchRepository>(
    () => UserSearchRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Chat Feature - Data sources
  sl.registerLazySingleton<UserSearchRemoteDataSource>(
    () => UserSearchRemoteDataSourceImpl(client: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
} 