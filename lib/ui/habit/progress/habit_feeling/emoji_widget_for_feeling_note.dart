import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

import 'custom_expansion_tile.dart';

class EmojiWidgetForFeelingNote extends StatefulWidget {
  final Function(int) onSelectedEmoji;
  final BorderRadius? borderRadius;
  final bool visibleHeader;

  const EmojiWidgetForFeelingNote({
    Key? key,
    required this.onSelectedEmoji,
    this.borderRadius,
    this.visibleHeader = true,
  }) : super(key: key);

  @override
  _EmojiWidgetForFeelingNoteState createState() => _EmojiWidgetForFeelingNoteState();
}

class _EmojiWidgetForFeelingNoteState extends State<EmojiWidgetForFeelingNote> {
  UniqueKey? keyTitle;
  int? _selectedIndex;
  bool isExpanded = true;

  // void _collape(){
  //   isExpanded = false;
  //   keyTitle = UniqueKey();
  // }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      borderRadius: widget.borderRadius,
      padding: SizeHelper.boxPadding,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: CustomExpansionTile(
          key: keyTitle,
          title: Text(
            _getText(),
            textAlign: TextAlign.center,
            style: TextStyle(height: 0, fontWeight: FontWeight.w500, fontSize: 15, color: _getColor((_selectedIndex ?? -1))),
          ),
          tilePadding: EdgeInsets.zero,
          isSelected: _selectedIndex != null ? true : false,
          initiallyExpanded: isExpanded,
          children: [
            /// Divider
            if (widget.visibleHeader) HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

            /// Emojis
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 1; i <= 4; i++) _emojiItem(i),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 5; i <= 8; i++) _emojiItem(i),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 9; i <= 12; i++) _emojiItem(i),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 13; i <= 16; i++) _emojiItem(i),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 17; i <= 20; i++) _emojiItem(i),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getText() {
    switch (_selectedIndex) {
      case 1:
        return LocaleKeys.happyEmoji;
      case 2:
        return LocaleKeys.frustratedEmoji;
      case 3:
        return LocaleKeys.surprisedEmoji;
      case 4:
        return LocaleKeys.lonelyEmoji;
      case 5:
        return LocaleKeys.sadEmoji;
      case 6:
        return LocaleKeys.underPressureEmoji;
      case 7:
        return LocaleKeys.unknownEmoji;
      case 8:
        return LocaleKeys.optimisticEmoji;
      case 9:
        return LocaleKeys.confidentEmoji;
      case 10:
        return LocaleKeys.worriedEmoji;
      case 11:
        return LocaleKeys.panickedEmoji;
      case 12:
        return LocaleKeys.satisfiedEmoji;
      case 13:
        return LocaleKeys.emotionlessEmoji;
      case 14:
        return LocaleKeys.calmEmoji;
      case 15:
        return LocaleKeys.thankfulEmoji;
      case 16:
        return LocaleKeys.anxiousEmoji;
      case 17:
        return LocaleKeys.angryEmoji;
      case 18:
        return LocaleKeys.lovedEmoji;
      case 19:
        return LocaleKeys.energeticEmoji;
      case 20:
        return LocaleKeys.tiredEmoji;
      default:
        return LocaleKeys.howIsYourFeeling;
    }
  }

  Widget _emojiItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onSelectedEmoji(index);
          // _collape();
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        height: 79.0,
        width: 70.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: _selectedIndex == index ? _getColor(index) : customColors.primaryBorder,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7.5)),
          color: _selectedIndex == index ? _getColor(index) : customColors.whiteBackground,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              _getAsset(index),
              height: 36,
              width: 36,
            ),
            SizedBox(height: 5),
            Text(
              _getTextWithIndex(index),
              style: TextStyle(
                fontSize: 10,
                fontFamily: FontAsset.FiraSansCondensed,
                color: _selectedIndex == index ? customColors.whiteBackground : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getAsset(int index) {
    switch (index) {
      case 1:
        return Assets.happyEmoji;
      case 2:
        return Assets.frustratedEmoji;
      case 3:
        return Assets.surprisedEmoji;
      case 4:
        return Assets.lonelyEmoji;
      case 5:
        return Assets.sadEmoji;
      case 6:
        return Assets.underPressureEmoji;
      case 7:
        return Assets.unknownEmoji;
      case 8:
        return Assets.optimisticEmoji;
      case 9:
        return Assets.confidentEmoji;
      case 10:
        return Assets.worriedEmoji;
      case 11:
        return Assets.panickedEmoji;
      case 12:
        return Assets.satisfiedEmoji;
      case 13:
        return Assets.emotionlessEmoji;
      case 14:
        return Assets.calmEmoji;
      case 15:
        return Assets.thankfulEmoji;
      case 16:
        return Assets.anxiousEmoji;
      case 17:
        return Assets.angryEmoji;
      case 18:
        return Assets.lovedEmoji;
      case 19:
        return Assets.energeticEmoji;
      case 20:
        return Assets.tiredEmoji;
    }

    return '';
  }

  Color _getColor(int index) {
    // switch (index) {
    //   case -1:
    //     return customColors.primaryText;
    //   case 1:
    //     return customColors.primary;
    //   case 2:
    //     return customColors.iconYellow;
    //   case 3:
    //     return customColors.iconBlue;
    //   case 4:
    //     return customColors.iconVikingGreen;
    //   case 5:
    //     return customColors.iconYellowGreen;
    // }

    return HexColor.fromHex('#EB86BE');
  }

  String _getTextWithIndex(int index) {
    switch (index) {
      case 1:
        return LocaleKeys.happyEmoji;
      case 2:
        return LocaleKeys.frustratedEmoji;
      case 3:
        return LocaleKeys.surprisedEmoji;
      case 4:
        return LocaleKeys.lonelyEmoji;
      case 5:
        return LocaleKeys.sadEmoji;
      case 6:
        return LocaleKeys.underPressureEmoji;
      case 7:
        return LocaleKeys.unknownEmoji;
      case 8:
        return LocaleKeys.optimisticEmoji;
      case 9:
        return LocaleKeys.confidentEmoji;
      case 10:
        return LocaleKeys.worriedEmoji;
      case 11:
        return LocaleKeys.panickedEmoji;
      case 12:
        return LocaleKeys.satisfiedEmoji;
      case 13:
        return LocaleKeys.emotionlessEmoji;
      case 14:
        return LocaleKeys.calmEmoji;
      case 15:
        return LocaleKeys.thankfulEmoji;
      case 16:
        return LocaleKeys.anxiousEmoji;
      case 17:
        return LocaleKeys.angryEmoji;
      case 18:
        return LocaleKeys.lovedEmoji;
      case 19:
        return LocaleKeys.energeticEmoji;
      case 20:
        return LocaleKeys.tiredEmoji;
      default:
        return LocaleKeys.howIsYourFeeling;
    }
  }
}
