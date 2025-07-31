import 'package:equatable/equatable.dart';

class UserSearchEntity extends Equatable {
  final String id;
  final String name;
  final String? image;
  final String? status;
  final DateTime? lastActive;

  const UserSearchEntity({
    required this.id,
    required this.name,
    this.image,
    this.status,
    this.lastActive,
  });

  @override
  List<Object?> get props => [id, name, image, status, lastActive];

  UserSearchEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? status,
    DateTime? lastActive,
  }) {
    return UserSearchEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      status: status ?? this.status,
      lastActive: lastActive ?? this.lastActive,
    );
  }
} 