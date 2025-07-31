import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomMessageInput extends StatefulWidget {
  const CustomMessageInput({super.key});

  @override
  State<CustomMessageInput> createState() => _CustomMessageInputState();
}

class _CustomMessageInputState extends State<CustomMessageInput> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamMessageInput(
      enableVoiceRecording: true, // Always enable to show the icon
    );
  }

} 