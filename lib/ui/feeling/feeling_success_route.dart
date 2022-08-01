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

class FeelingSuccessRoute extends StatefulWidget {
  final VoidCallback? callback;

  const FeelingSuccessRoute({
    Key? key,
    this.callback,
  }) : super(key: key);

  @override
  _FeelingSuccessRouteState createState() => _FeelingSuccessRouteState();
}

class _FeelingSuccessRouteState extends State<FeelingSuccessRoute> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.fromLTRB(45, 0, 45, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Platform.isAndroid ? 240 : 260,
            ),

            SvgPicture.asset(Assets.group_of_mood),
            SizedBox(
              height: 26,
            ),

            CustomText(
              LocaleKeys.thankYouForSharingEmotions,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              maxLines: 3,
              color: customColors.whiteText,
              alignment: Alignment.center,
            ),

            Expanded(child: Container()),

            /// Button finish
            CustomButton(
              text: LocaleKeys.thanksHabiDo,
              style: CustomButtonStyle.primary,
              onPressed: () {
                if (widget.callback != null) widget.callback!();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
