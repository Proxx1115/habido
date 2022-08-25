import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class EmptyHabitWidget extends StatelessWidget {
  final String image;
  final String text;
  const EmptyHabitWidget(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 120),
      height: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              image,
              width: 255,
              height: 251,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          CustomText(
            text,
            alignment: Alignment.center,
            fontSize: 15.0,
            maxLines: 2,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
