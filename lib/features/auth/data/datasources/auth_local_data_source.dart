import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<void> saveStreamToken(String token);
  Future<String?> getStreamToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  AuthLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(
      AppConstants.userDataKey,
      jsonEncode(user.toJson()),
    );
  }
  
  @override
  Future<UserModel?> getUser() async {
    final userJson = sharedPreferences.getString(AppConstants.userDataKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  
  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(AppConstants.userDataKey);
    await sharedPreferences.remove(AppConstants.streamTokenKey);
  }
  
  @override
  Future<void> saveStreamToken(String token) async {
    await sharedPreferences.setString(AppConstants.streamTokenKey, token);
  }
  
  @override
  Future<String?> getStreamToken() async {
    return sharedPreferences.getString(AppConstants.streamTokenKey);
  }
} 