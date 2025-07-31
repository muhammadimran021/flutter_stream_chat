import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? streamToken;
  
  const User({
    required this.id,
    required this.email,
    required this.username,
    this.streamToken,
  });
  
  @override
  List<Object?> get props => [id, email, username, streamToken];
  
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? streamToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      streamToken: streamToken ?? this.streamToken,
    );
  }
} 