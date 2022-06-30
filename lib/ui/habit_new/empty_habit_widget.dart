import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/widgets/text.dart';

class EmptyHabitWidget extends StatelessWidget {
  final String image;
  final String text;
  const EmptyHabitWidget(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: MediaQuery.of(context).size.height / 2,
        left: MediaQuery.of(context).size.width / 2,
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 284.0,
                width: 255.0,
                child: SvgPicture.asset(
                  image,
                ),
              ),
              CustomText(
                text,
                fontSize: 15.0,
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
