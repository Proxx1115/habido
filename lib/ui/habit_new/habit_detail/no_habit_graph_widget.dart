import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/text.dart';

class NoHabitGraph extends StatelessWidget {
  const NoHabitGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 26),
            child: SvgPicture.asset(
              Assets.empty_calendar,
              width: 126,
              height: 122,
            ),
          ),
          CustomText(
            LocaleKeys.noExecutionYet,
            fontWeight: FontWeight.w500,
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}
