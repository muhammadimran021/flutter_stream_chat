import 'package:flutter/cupertino.dart';
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
        appBar: StreamThreadHeader(
          parent: parent,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamMessageListView(
                parentMessage: parent,
              ),
            ),
            StreamMessageInput(
            ),
          ],
        ),
      ),
    );
  }
}
