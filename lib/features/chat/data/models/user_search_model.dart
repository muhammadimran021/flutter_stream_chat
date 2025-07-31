import '../../domain/entities/user_search_entity.dart';

class UserSearchModel extends UserSearchEntity {
  const UserSearchModel({
    required super.id,
    required super.name,
    super.image,
    super.status,
    super.lastActive,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    return UserSearchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? json['id'] ?? 'Unknown User',
      image: json['image'],
      status: json['status'],
      lastActive: json['last_active'] != null 
          ? DateTime.parse(json['last_active']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'last_active': lastActive?.toIso8601String(),
    };
  }

  factory UserSearchModel.fromStreamUser(dynamic streamUser) {
    return UserSearchModel(
      id: streamUser.id ?? '',
      name: streamUser.name ?? streamUser.id ?? 'Unknown User',
      image: streamUser.image ??'',
      status: streamUser.online ? 'online' : 'offline',
      lastActive: streamUser.lastActive,
    );
  }
} 