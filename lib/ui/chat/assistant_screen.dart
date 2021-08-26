import 'package:flutter/material.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/ui/chat/chat_screen.dart';
import 'package:habido_app/ui/home/home_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/app_bars.dart';
import 'package:habido_app/widgets/scaffold.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({Key? key}) : super(key: key);

  @override
  _AssistantScreenState createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          /// Calendar, Title, Notification
          HomeAppBar(title: LocaleKeys.habidoAssistant),

          /// Habido assistant image
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
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
