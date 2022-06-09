import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/feeling/btn_back_widget.dart';
import 'package:habido_app/ui/feeling/emoji_item_widget.dart';
import 'package:habido_app/ui/feeling/btn_next_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingEmojiRoute extends StatefulWidget {
  final selectedFeelingData;
  const FeelingEmojiRoute({Key? key, this.selectedFeelingData}) : super(key: key);

  @override
  State<FeelingEmojiRoute> createState() => _FeelingEmojiRouteState();
}

class _FeelingEmojiRouteState extends State<FeelingEmojiRoute> {
  final _feelingMainKey = GlobalKey<ScaffoldState>();

  Map? _selectedFeelingEmoji;

  // List<String> _awesomeEmojis = [
  //   Assets.powerfulEmoji_new,
  //   Assets.thankfulEmoji_new,
  //   Assets.confidentEmoji_new,
  //   Assets.satisfiedEmoji_new,
  //   Assets.happyEmoji_new,
  //   Assets.lovedEmoji_new,
  //   Assets.optimisticEmoji_new,
  //   Assets.calmEmoji_new,
  //   Assets.encouragingEmoji_new,
  //   Assets.relaxedEmoji_new,
  //   Assets.proudEmoji_new,
  //   Assets.unknownEmoji_new,
  // ];
  // List<String> _awesomeTexts = [
  //   LocaleKeys.powerfulEmoji_new,
  //   LocaleKeys.thankfulEmoji_new,
  //   LocaleKeys.confidentEmoji_new,
  //   LocaleKeys.satisfiedEmoji_new,
  //   LocaleKeys.happyEmoji_new,
  //   LocaleKeys.lovedEmoji_new,
  //   LocaleKeys.optimisticEmoji_new,
  //   LocaleKeys.calmEmoji_new,
  //   LocaleKeys.encouragingEmoji_new,
  //   LocaleKeys.relaxedEmoji_new,
  //   LocaleKeys.proudEmoji_new,
  //   LocaleKeys.unknownEmoji_new,
  // ];
  List _emojiData = [
    {"emoji": Assets.powerfulEmoji_new, "name": LocaleKeys.powerfulEmoji_new},
    {"emoji": Assets.thankfulEmoji_new, "name": LocaleKeys.thankfulEmoji_new},
    {"emoji": Assets.confidentEmoji_new, "name": LocaleKeys.confidentEmoji_new},
    {"emoji": Assets.satisfiedEmoji_new, "name": LocaleKeys.satisfiedEmoji_new},
    {"emoji": Assets.happyEmoji_new, "name": LocaleKeys.happyEmoji_new},
    {"emoji": Assets.lovedEmoji_new, "name": LocaleKeys.lovedEmoji_new},
    {"emoji": Assets.optimisticEmoji_new, "name": LocaleKeys.optimisticEmoji_new},
    {"emoji": Assets.calmEmoji_new, "name": LocaleKeys.calmEmoji_new},
    {"emoji": Assets.encouragingEmoji_new, "name": LocaleKeys.encouragingEmoji_new},
    {"emoji": Assets.relaxedEmoji_new, "name": LocaleKeys.relaxedEmoji_new},
    {"emoji": Assets.proudEmoji_new, "name": LocaleKeys.proudEmoji_new},
    {"emoji": Assets.unknownEmoji_new, "name": LocaleKeys.unknownEmoji_new},
    {"emoji": Assets.calmEmoji_new, "name": LocaleKeys.calmEmoji_new},
    {"emoji": Assets.encouragingEmoji_new, "name": LocaleKeys.encouragingEmoji_new},
    {"emoji": Assets.relaxedEmoji_new, "name": LocaleKeys.relaxedEmoji_new},
    {"emoji": Assets.proudEmoji_new, "name": LocaleKeys.proudEmoji_new},
    {"emoji": Assets.unknownEmoji_new, "name": LocaleKeys.unknownEmoji_new},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Gridview - dynamic spacing
    double _crossAxisSpacing = (width - 90.0 * 3 - SizeHelper.margin * 2) / 2; // todo change
    double _mainAxisSpacing = _crossAxisSpacing; // todo change

    return CustomScaffold(
      scaffoldKey: _feelingMainKey,
      child: Container(
        padding: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, SizeHelper.margin, 0.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.selectedFeelingData["colors"],
        )),
        child: Column(
          children: [
            ButtonBackWidget(onTap: _navigatePop),

            SizedBox(height: 28.0),

            /// Question
            Container(
              child: CustomText(
                LocaleKeys.howsYourDay, // todo dynamic
                color: customColors.whiteText,
                fontWeight: FontWeight.w700,
                fontSize: 27.0,
                maxLines: 3,
              ),
            ),

            SizedBox(height: 39.0),

            /// Emoji Item List
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(SizeHelper.padding),
                crossAxisSpacing: _crossAxisSpacing,
                childAspectRatio: 1,
                crossAxisCount: 3,
                mainAxisSpacing: _mainAxisSpacing,
                children: [
                  for (var i = 0; i < _emojiData.length; i++)
                    EmojiItemWidget(
                      emojiData: _emojiData[i],
                      isSelected: _selectedFeelingEmoji == _emojiData[i],
                      onTap: () {
                        setState(() {
                          _selectedFeelingEmoji = _emojiData[i];
                        });
                      },
                    )
                ],
              ),
            ),

            SizedBox(height: 30.0),

            ButtonNextWidget(
              onTap: _navigateToFeelingEmojiRoute,
              isVisible: _selectedFeelingEmoji != null && _selectedFeelingEmoji!.isNotEmpty,
            ),

            SizedBox(height: 30.0)
          ],
        ),
      ),
    );
  }

  _navigateToFeelingEmojiRoute() {
    Navigator.pushNamed(
      context,
      Routes.feelingCause,
      arguments: {
        'selectedFeelingData': widget.selectedFeelingData,
      },
    );
  }

  _navigatePop() {
    Navigator.popUntil(context, ModalRoute.withName(Routes.feelingMain));
  }
}
