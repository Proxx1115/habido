import 'package:flutter/material.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/ui/chat/chat_screen.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';
import 'package:habido_app/widgets/scaffold.dart';

class ChatbotDashboard extends StatefulWidget {
  const ChatbotDashboard({Key? key}) : super(key: key);

  @override
  _ChatbotDashboardState createState() => _ChatbotDashboardState();
}

class _ChatbotDashboardState extends State<ChatbotDashboard> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          /// Calendar, Title, Notification
          DashboardAppBar(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            title: LocaleKeys.habidoAssistant,
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
