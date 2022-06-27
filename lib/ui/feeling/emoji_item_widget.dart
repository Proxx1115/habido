import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class EmojiItemWidget extends StatefulWidget {
  final MoodTrackerAnswer emojiData;
  final Function onTap;
  final bool isSelected;
  final bool isBold;
  const EmojiItemWidget({Key? key, required this.emojiData, required this.onTap, required this.isSelected, this.isBold = false}) : super(key: key);

  @override
  State<EmojiItemWidget> createState() => _EmojiItemWidgetState();
}

class _EmojiItemWidgetState extends State<EmojiItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 95,
        width: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: widget.isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
            color: Colors.white.withOpacity(0.29)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.emojiData.answerImageUrl!,
              // placeholder: (context, url) => CustomLoader(context, size: 20.0),
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.0),
            CustomText(
              widget.emojiData.answerText,
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              fontWeight: widget.isBold ? FontWeight.w700 : FontWeight.normal,
              fontSize: 11.0,
            ),
          ],
        ),
      ),
    );
  }
}

class EmojiItemWithDateWidget extends StatelessWidget {
  final Map emojiData;
  final Function onTap;

  const EmojiItemWithDateWidget({
    Key? key,
    required this.emojiData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        onTap();
      },
      child: Container(
        height: 97,
        width: 78,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            SvgPicture.asset(
              emojiData["emoji"],
              height: 37.8,
              width: 37.8,
            ),
            SizedBox(height: 4.0),
            CustomText(
              emojiData["name"],
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              fontSize: 11.0,
            ),
            SizedBox(height: 4.0),
            CustomText(
              emojiData["date"],
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              fontSize: 9.0,
              color: customColors.disabledText,
            ),
            CustomText(
              emojiData["time"],
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              fontSize: 9.0,
              color: customColors.disabledText,
            ),
          ],
        ),
      ),
    );
  }
}
