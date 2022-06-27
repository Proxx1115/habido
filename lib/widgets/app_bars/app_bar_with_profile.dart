import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class AppBarWithProfile extends StatelessWidget {
  final String? backIcon;
  final String text;
  final String? firstIcon;
  final Function()? firstFunc;
  final String? secondIcon;
  final Function()? secondFunc;

  const AppBarWithProfile(
      {Key? key,
      this.backIcon,
      required this.text,
      this.firstIcon,
      this.firstFunc,
      this.secondIcon,
      this.secondFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (backIcon != null)
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: SvgPicture.asset(
                      backIcon!,
                      fit: BoxFit.scaleDown,
                      color: customColors.iconGrey,
                      height: 15,
                    ),
                  ),
                ),
              SizedBox(width: 15),
              CustomText(
                text,
                fontSize: 16,
              ),
            ],
          ),
          Row(
            children: [
              if (firstIcon != null)
                InkWell(
                  onTap: firstFunc,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: SvgPicture.asset(
                      firstIcon!,
                      fit: BoxFit.scaleDown,
                      color: customColors.iconGrey,
                    ),
                  ),
                ),
              SizedBox(width: 15),
              if (secondIcon != null)
                InkWell(
                  onTap: secondFunc,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: SvgPicture.asset(
                      secondIcon!,
                      fit: BoxFit.scaleDown,
                      color: customColors.iconGrey,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
