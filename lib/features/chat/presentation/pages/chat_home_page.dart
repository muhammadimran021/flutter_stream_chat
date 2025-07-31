import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_chat/features/chat/presentation/pages/thread_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/custom_message_input.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
    channelStateSort: const [SortOption.desc('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
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
        onChannelLongPress: (channel) {
          _showChannelOptionsDialog(context, channel);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateChannelDialog(context),
        child: const Icon(Icons.add),
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
    final currentUserId = client.state.currentUser!.id; // Use ID instead of name

    final members = [currentUserId];
    if (memberIds.isNotEmpty) {
      members.addAll(
        memberIds.split(',').map((id) => id.trim()).where((id) => id.isNotEmpty),
      );
    }

    // Sort members to ensure consistent channel ID
    members.sort();
    final channelId = 'group_${members.join('_')}';

    final channel = client.channel(
      'messaging',
      id: channelId,
      extraData: {
        'name': channelName,
        'image': 'https://example.com/group.png',
      },
    );

    // Watch the channel and add members
    channel.watch().then((_) {
      channel.addMembers(members);
    });
  }

  void _showChannelOptionsDialog(BuildContext context, Channel channel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Channel', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(context, channel);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Channel channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Channel'),
        content: Text(
          'Are you sure you want to delete "${channel.name ?? channel.id}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteChannel(channel);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChannel(Channel channel) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Deleting channel...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Delete the channel
      await channel.delete();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Channel "${channel.name ?? channel.id}" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete channel: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              threadBuilder: (_, parentMessage) {
                return ThreadPage(
                  parent: parentMessage!,
                );
              },
            ),
          ),
          const CustomMessageInput(),
        ],
      ),
    );
  }

}