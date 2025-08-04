import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../core/theme/stream_chat_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/user_search_entity.dart';
import '../bloc/user_search_bloc.dart';
import '../bloc/user_search_event.dart';
import '../bloc/user_search_state.dart';
import '../widgets/custom_message_input.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({super.key});

  @override
  State<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // No initial user fetch - wait for user to start typing
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<UserSearchBloc>().add(ClearSearch());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: StreamChatAppTheme.surfaceColor,
              ),
              onChanged: (value) {
                if (value.length >= 2) {
                  context.read<UserSearchBloc>().add(SearchUsers(query: value));
                } else if (value.isEmpty) {
                  context.read<UserSearchBloc>().add(ClearSearch());
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<UserSearchBloc, UserSearchState>(
              builder: (context, state) {
                if (state is UserSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserSearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: StreamChatAppTheme.errorColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: StreamChatAppTheme.errorColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<UserSearchBloc>().add(ClearSearch());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is UserSearchLoaded) {
                  if (state.users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.query != null ? Icons.search : Icons.people,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No users found for "${state.query}"',
                            style: TextStyle(
                              color: StreamChatAppTheme.secondaryTextColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return _buildUserTile(user);
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: StreamChatAppTheme.disabledTextColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Type to search for users',
                          style: TextStyle(
                            color: StreamChatAppTheme.secondaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter at least 2 characters to start searching',
                          style: TextStyle(
                            color: StreamChatAppTheme.disabledTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(UserSearchEntity user) {
    final currentUser = StreamChat.of(context).currentUser;
    if (currentUser != null && currentUser.id == user.id) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
        child: user.image == null
            ? Text(
                user.name.isNotEmpty
                    ? user.name.substring(0, 1).toUpperCase()
                    : 'U',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : null,
      ),
      title: Text(
        user.name.isNotEmpty ? user.name : 'Unknown User',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(user.id),
      trailing: ElevatedButton(
        onPressed: () => _startConversation(user),
        style: ElevatedButton.styleFrom(
          backgroundColor: StreamChatAppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Message'),
      ),
    );
  }

  Future<void> _startConversation(UserSearchEntity user) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final client = StreamChat.of(context).client;
      final currentUser = client.state.currentUser!;
      final memberIds = [currentUser.id, user.id]..sort(); // consistent order
      final channelId = memberIds.join('-');

      // Create or get the channel with members
      final channel = client.channel(
        'messaging',
        id: channelId,
        extraData: {
          'members': memberIds,
        },
      );

      // Safely watch the channel (creates it if it doesn't exist)
      await channel.watch();

      // Navigate to the chat
      if (mounted) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) =>
                StreamChannel(channel: channel, child: const ChannelPage()),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error starting conversation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}

class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              messageFilter: (message) => message.parentId == null, // Hide threaded messages
            ),
          ),
          const CustomMessageInput(),
        ],
      ),
    );
  }
}
