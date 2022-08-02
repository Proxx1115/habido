import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/audio_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitSuccessRouteNew extends StatefulWidget {
  final VoidCallback? callback;

  const HabitSuccessRouteNew({
    Key? key,
    this.callback,
  }) : super(key: key);

  @override
  _HabitSuccessRouteNewState createState() => _HabitSuccessRouteNewState();
}

class _HabitSuccessRouteNewState extends State<HabitSuccessRouteNew> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    AudioManager.playAsset(AudioAsset.success);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: customColors.primaryBackground,
      padding: EdgeInsets.fromLTRB(45, 0, 45, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Platform.isAndroid ? 130 : 160,
          ),

          SvgPicture.asset(Assets.habit_success),
          SizedBox(
            height: 26,
          ),

          CustomText(
            LocaleKeys.thankYouForImprovingUrself,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            maxLines: 3,
            color: customColors.primary,
            alignment: Alignment.center,
          ),

          Expanded(child: Container()),

          /// Button finish
          CustomButton(
            text: LocaleKeys.close,
            style: CustomButtonStyle.primary,
            onPressed: () {
              Navigator.pop(context);
              if (widget.callback != null) widget.callback!();
            },
          ),
        ],
      ),
    );
  }
}
