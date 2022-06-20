import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';

class ButtonBackWidget extends StatelessWidget {
  final Function onTap;
  const ButtonBackWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 35.0,
            width: 35.0,
            padding: EdgeInsets.all(13.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: SvgPicture.asset(
              Assets.arrow_back,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
