import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/chat_bloc.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/ui/chat/chat_screen.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';

class HabidoAssistantRoute extends StatefulWidget {
  @override
  _HabidoAssistantRouteState createState() => _HabidoAssistantRouteState();
}

class _HabidoAssistantRouteState extends State<HabidoAssistantRoute> {
  // UI
  final _habidoAssistantKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        key: _habidoAssistantKey,
        backgroundColor: customColors.primaryBackground,
        appBar: CustomAppBar(
          context,
          titleText: LocaleKeys.habidoAssistant,
          leadingAsset: null,
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

            /// Chat widget
            Expanded(
              child: ChatScreen(chatType: ChatType.onBoarding),
            ),
          ],
        ),
      ),
    );
  }
}
