import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
    channelStateSort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChatTheme(
      data: StreamChatThemeData.light(),
      child: Portal(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Stream Chat'),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              ),
            ],
          ),
          body: StreamChannelListView(
            controller: _listController,
            onChannelTap: (channel) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return StreamChannel(
                      channel: channel,
                      child: const ChannelPage(),
                    );
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateChannelDialog(context),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showCreateChannelDialog(BuildContext context) {
    final channelNameController = TextEditingController();
    final memberIdsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Channel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: channelNameController,
              decoration: const InputDecoration(
                labelText: 'Channel Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: memberIdsController,
              decoration: const InputDecoration(
                labelText: 'Member IDs (comma separated)',
                border: OutlineInputBorder(),
                hintText: 'user1,user2,user3',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (channelNameController.text.isNotEmpty) {
                _createChannel(
                  channelNameController.text,
                  memberIdsController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createChannel(String channelName, String memberIds) {
    final client = StreamChat.of(context).client;
    final currentUserId = client.state.currentUser!.extraData['name'] as String;
    
    final members = [currentUserId];
    if (memberIds.isNotEmpty) {
      members.addAll(
        memberIds.split(',').map((id) => id.trim()).where((id) => id.isNotEmpty),
      );
    }

    final channelId = 'group_${members.join('_')}';
    
    final channel = client.channel(
      'messaging',
      id: channelId,
      extraData: {
        'name': channelName,
        'image': 'https://example.com/group.png',
        'members': members,
      },
    );
    
    channel.watch();
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamChatTheme(
      data: StreamChatThemeData.light(),
      child: Scaffold(
        appBar: const StreamChannelHeader(),
        body: Column(
          children: const <Widget>[
            Expanded(child: StreamMessageListView()),
            StreamMessageInput(),
          ],
        ),
      ),
    );
  }
} 