import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/widgets/text.dart';

class EmptyHabitWidget extends StatelessWidget {
  final String image;
  final String text;
  const EmptyHabitWidget(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: _size.width * 0.2, vertical: _size.height * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              image,
              width: double.infinity,
            ),
          ),
          CustomText(
            text,
            alignment: Alignment.center,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
