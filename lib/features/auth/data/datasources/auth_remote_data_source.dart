import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
    required String username,
  });
  
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  
  AuthRemoteDataSourceImpl({required this.dio});
  
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.supabaseUrl}${AppConstants.streamAuthEndpoint}',
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        return UserModel(
          id: data['user']['id'],
          email: data['user']['email'],
          username: data['user']['username'],
          streamToken: data['streamToken'],
        );
      } else {
        throw Exception('Authentication failed');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        throw Exception(errorData['error'] ?? 'Authentication failed');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }
  
  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    // For this implementation, sign up uses the same endpoint as sign in
    // The edge function handles both cases
    return await signIn(
      email: email,
      password: password,
      username: username,
    );
  }
} 