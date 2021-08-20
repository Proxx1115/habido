import 'package:flutter/material.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/ui/chat/chat_screen.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/app_bars.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({Key? key}) : super(key: key);

  @override
  _AssistantScreenState createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leadingAsset: Assets.calendar,
        onPressedLeading: () {
          print('todo test');
        },
      ),
      body: Column(
        children: [
          /// Habido assistant image
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Image.asset(Assets.habido_assistant_png),
            ),
          ),

          /// Chat
          Expanded(
            child: ChatScreen(chatType: ChatType.assistant),
          ),
        ],
      ),
    );
  }
}
