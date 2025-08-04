import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadPage extends StatelessWidget {
  final Message parent;

  const ThreadPage({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    return StreamChannel(
      channel: channel,
      child: Scaffold(
        appBar: StreamThreadHeader(parent: parent),
        body: Column(
          children: [
            Expanded(child: StreamMessageListView(parentMessage: parent)),
            StreamMessageInput(
              onMessageSent: (messageText) {
                sendThreadedMessage(
                  channel,
                  parent.id,
                  messageText.text.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendThreadedMessage(
    Channel channel,
    String parentMessageId,
    String text,
  ) async {
    await channel.sendMessage(
      Message(
        showInChannel: false,
        parentId: parentMessageId, // Associates with the parent message
        text: text,
      ),
    );
  }
}
