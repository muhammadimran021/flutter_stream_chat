import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../models/user_search_model.dart';

abstract class UserSearchRemoteDataSource {
  Future<List<UserSearchModel>> searchUsers(String query);
  Future<List<UserSearchModel>> getRecentUsers();
}

class UserSearchRemoteDataSourceImpl implements UserSearchRemoteDataSource {
  final StreamChatClient client;

  UserSearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserSearchModel>> searchUsers(String query) async {
    try {
      final currentUser = client.state.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final result = await client.queryUsers(
        filter: Filter.and([
          Filter.autoComplete('name', query),
          Filter.notEqual('id', currentUser.id),
        ]),
      );

      return result.users
          .map((user) => UserSearchModel.fromStreamUser(user))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<List<UserSearchModel>> getRecentUsers() async {
    try {
      final currentUser = client.state.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final result = await client.queryUsers(
        filter: Filter.notEqual('id', currentUser.id),
      );

      return result.users
          .map((user) => UserSearchModel.fromStreamUser(user))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent users: $e');
    }
  }
} 