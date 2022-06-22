import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/feeling/emoji_item_widget.dart';
import 'package:habido_app/ui/feeling/btn_next_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingMainRoute extends StatefulWidget {
  const FeelingMainRoute({Key? key}) : super(key: key);

  @override
  State<FeelingMainRoute> createState() => _FeelingMainRouteState();
}

class _FeelingMainRouteState extends State<FeelingMainRoute> {
  // UI
  final _feelingMainKey = GlobalKey<ScaffoldState>();

  late Map _selectedFeelingData;

  // Testing data
  Map _feeling1 = {
    "name": LocaleKeys.emoji1,
    "colors": [customColors.feeling1Top, customColors.feeling1Btm],
    "emoji": Assets.emoji1,
  };
  Map _feeling2 = {
    "name": LocaleKeys.emoji2,
    "colors": [customColors.feeling2Top, customColors.feeling2Btm],
    "emoji": Assets.emoji2
  };
  Map _feeling3 = {
    "name": LocaleKeys.emoji3,
    "colors": [customColors.feeling3Top, customColors.feeling3Btm],
    "emoji": Assets.emoji3
  };
  Map _feeling4 = {
    "name": LocaleKeys.emoji4,
    "colors": [customColors.feeling4Top, customColors.feeling4Btm],
    "emoji": Assets.emoji4
  };
  Map _feeling5 = {
    "name": LocaleKeys.emoji5,
    "colors": [customColors.feeling5Top, customColors.feeling5Btm],
    "emoji": Assets.emoji5
  };

  @override
  void initState() {
    setState(() {
      _selectedFeelingData = _feeling1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _feelingMainKey,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _selectedFeelingData["colors"],
        )),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                _closeBtn(),

                SizedBox(height: 28.0),

                /// Question
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 64.0),
                  child: CustomText(
                    LocaleKeys.howsYourDay,
                    color: customColors.whiteText,
                    alignment: Alignment.center,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    fontSize: 27.0,
                    maxLines: 2,
                  ),
                ),

                SizedBox(height: 53.0),

                SvgPicture.asset(
                  _selectedFeelingData["emoji"],
                  height: 150,
                  width: 150,
                ),

                SizedBox(height: 14.0),

                /// Feeling Name
                CustomText(
                  _selectedFeelingData["name"],
                  color: customColors.whiteText,
                  alignment: Alignment.center,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  fontSize: 25.0,
                ),

                SizedBox(height: 55.0),

                /// General Feelings list
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmojiItemWidget(
                      emojiData: _feeling1,
                      isSelected: _selectedFeelingData == _feeling1,
                      isBold: true,
                      onTap: () {
                        setState(() {
                          _selectedFeelingData = _feeling1;
                        });
                      },
                    ),

                    SizedBox(width: 15.0),

                    EmojiItemWidget(
                      emojiData: _feeling2,
                      isSelected: _selectedFeelingData == _feeling2,
                      isBold: true,
                      onTap: () {
                        setState(() {
                          _selectedFeelingData = _feeling2;
                        });
                      },
                    ),

                    SizedBox(width: 15.0),

                    EmojiItemWidget(
                      emojiData: _feeling3,
                      isSelected: _selectedFeelingData == _feeling3,
                      isBold: true,
                      onTap: () {
                        setState(() {
                          _selectedFeelingData = _feeling3;
                        });
                      },
                    ),
                    // _EmojiItemWidget(_feeling3),
                  ],
                ),

                SizedBox(height: 15.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmojiItemWidget(
                      emojiData: _feeling4,
                      isSelected: _selectedFeelingData == _feeling4,
                      isBold: true,
                      onTap: () {
                        setState(() {
                          _selectedFeelingData = _feeling4;
                        });
                      },
                    ),
                    SizedBox(width: 15.0),
                    EmojiItemWidget(
                      emojiData: _feeling5,
                      isSelected: _selectedFeelingData == _feeling5,
                      isBold: true,
                      onTap: () {
                        setState(() {
                          _selectedFeelingData = _feeling5;
                        });
                      },
                    ),
                  ],
                ),
              ],
            )),
            SizedBox(height: 30.0),
            ButtonNextWidget(onTap: _navigateToFeelingEmojiRoute, progressValue: 0.25),
            SizedBox(height: 30.0)
          ],
        ),
      ),
    );
  }

  Widget _closeBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home_new));
          },
          child: Container(
            height: 35.0,
            width: 35.0,
            margin: EdgeInsets.fromLTRB(0.0, SizeHelper.margin, SizeHelper.margin, 0.0),
            padding: EdgeInsets.all(13.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Image.asset(
              Assets.exit,
            ),
          ),
        )
      ],
    );
  }

  _navigateToFeelingEmojiRoute() {
    Navigator.pushNamed(
      context,
      Routes.feelingEmoji,
      arguments: {
        'selectedFeelingData': _selectedFeelingData,
      },
    );
  }
}
