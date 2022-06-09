import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/widgets/text.dart';

class EmojiItemWidget extends StatefulWidget {
  final Map emojiData;
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
            SvgPicture.asset(
              widget.emojiData["emoji"],
              height: 40,
              width: 40,
            ),
            SizedBox(height: 8.0),
            CustomText(
              widget.emojiData["name"],
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
