import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class EmojiWidget extends StatefulWidget {
  final Function(int) onSelectedEmoji;
  final BorderRadius? borderRadius;
  final bool visibleHeader;

  const EmojiWidget({
    Key? key,
    required this.onSelectedEmoji,
    this.borderRadius,
    this.visibleHeader = true,
  }) : super(key: key);

  @override
  _EmojiWidgetState createState() => _EmojiWidgetState();
}

class _EmojiWidgetState extends State<EmojiWidget> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      borderRadius: widget.borderRadius,
      padding: SizeHelper.boxPadding,
      child: Column(
        children: [
          /// Text
          if (widget.visibleHeader)
            CustomText(
              _getText(),
              fontWeight: FontWeight.w500,
              alignment: Alignment.center,
              color: _getColor(_selectedIndex ?? -1),
            ),

          /// Divider
          if (widget.visibleHeader) HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Emojis
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 1; i <= 5; i++) _emojiItem(i),
            ],
          ),
        ],
      ),
    );
  }

  String _getText() {
    switch (_selectedIndex) {
      case 1:
        return LocaleKeys.emoji1;
      case 2:
        return LocaleKeys.emoji2;
      case 3:
        return LocaleKeys.emoji3;
      case 4:
        return LocaleKeys.emoji4;
      case 5:
        return LocaleKeys.emoji5;
      default:
        return LocaleKeys.pleaseSelectEmoji;
    }
  }

  Widget _emojiItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onSelectedEmoji(index);
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: SizeHelper.borderWidth,
            color: _selectedIndex == index ? _getColor(index) : customColors.primaryBorder,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: _selectedIndex == index ? _getColor(index) : customColors.secondaryBackground,
        ),
        child: SvgPicture.asset(
          _getAsset(index),
          color: _selectedIndex == index ? customColors.iconWhite : _getColor(index),
        ),
      ),
    );
  }

  String _getAsset(int index) {
    switch (index) {
      case 1:
        return Assets.emoji1;
      case 2:
        return Assets.emoji2;
      case 3:
        return Assets.emoji3;
      case 4:
        return Assets.emoji4;
      case 5:
        return Assets.emoji5;
    }

    return '';
  }

  Color _getColor(int index) {
    switch (index) {
      case -1:
        return customColors.primaryText;
      case 1:
        return customColors.primary;
      case 2:
        return customColors.iconYellow;
      case 3:
        return customColors.iconBlue;
      case 4:
        return customColors.iconVikingGreen;
      case 5:
        return customColors.iconYellowGreen;
    }

    return customColors.iconGrey;
  }
}
