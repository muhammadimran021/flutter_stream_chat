import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.streamToken,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      streamToken: json['streamToken'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'streamToken': streamToken,
    };
  }
  
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      streamToken: user.streamToken,
    );
  }
  
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      streamToken: streamToken,
    );
  }
  
  static String toJsonString(User user) {
    return jsonEncode(UserModel.fromEntity(user).toJson());
  }
  
  static User fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString)).toEntity();
  }
} 