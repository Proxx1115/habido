import 'package:flutter/material.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/ui/chat/chat_screen.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class ChatbotDashboard extends StatefulWidget {
  const ChatbotDashboard({Key? key}) : super(key: key);

  @override
  _ChatbotDashboardState createState() => _ChatbotDashboardState();
}

class _ChatbotDashboardState extends State<ChatbotDashboard> {
  bool _soon = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: _soon
          ? _hint()
          : Column(
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

  Widget _hint() {
    return Column(
      children: [
        /// Calendar, Title, Notification
        DashboardAppBar(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          title: LocaleKeys.habidoAssistant,
        ),

        Expanded(child: Container()),
        Stack(
          children: [
            StadiumContainer(
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, 45.0,
                  SizeHelper.margin, SizeHelper.margin),
              padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HorizontalLine(),
                  CustomText(
                    'Сайн уу? Намайг HabiDo чатбот гэдэг.',
                    margin: EdgeInsets.only(top: SizeHelper.margin),
                    maxLines: 5,
                    alignment: Alignment.center,
                  ),
                  CustomText(
                    'Би таны сэтгэл зүйг дэмжих найз байх болно.',
                    margin: EdgeInsets.only(
                        top: SizeHelper.margin, bottom: SizeHelper.margin),
                    maxLines: 5,
                    alignment: Alignment.center,
                  ),
                  HorizontalLine(),
                  CustomText(
                    'Удахгүй уулзацгаая...',
                    margin: EdgeInsets.only(top: SizeHelper.margin),
                    maxLines: 5,
                    alignment: Alignment.center,
                    color: customColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),

            /// Habido assistant image
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Image.asset(Assets.habido_assistant_png,
                    height: 50.0, width: 50.0),
              ),
            ),
          ],
        ),
        Expanded(child: Container()),
        SizedBox(height: 80.0),
      ],
    );
  }
}
