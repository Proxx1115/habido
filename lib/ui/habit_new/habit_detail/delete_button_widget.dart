import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class DeleteButtonWidget extends StatelessWidget {
  final Function onDelete;
  const DeleteButtonWidget({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          showCustomDialog(
            context,
            isDismissible: true,
            child: CustomDialogBody(
              asset: Assets.warning,
              text: LocaleKeys.sureToDelete,
              buttonText: LocaleKeys.yes,
              onPressedButton: () {
                onDelete();
              },
              button2Text: LocaleKeys.no,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: customColors.whiteBackground,
          ),
          child: IntrinsicWidth(
            child: Row(children: [
              SvgPicture.asset(
                Assets.trash,
                height: 13.0,
                color: customColors.iconLightGrey,
              ),

              ///
              SizedBox(width: 12.0),

              CustomText(
                LocaleKeys.giveUp,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: customColors.lightGreyText,
              ),
            ]),
          ),
        ),
      ),
    );
    // ButtonStadium(
    //       style: ButtonStadiumStyle.Primary,
    //       asset: Assets.trash,
    //       iconColor: customColors.iconRed,
    //       margin: EdgeInsets.only(top: 15.0),
    //       onPressed: () {

    //       },
    //     );
  }
}
