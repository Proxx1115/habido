import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class CustomIconPicker extends StatelessWidget {
  CustomIconPicker({
    Key? key,
    required this.iconList,
    this.selectedIcon,
    this.onIconSelected,
    this.margin,
    this.primaryColor,
  }) : super(key: key);

  final List<CustomHabitIcon> iconList;
  final CustomHabitIcon? selectedIcon;
  final Function(CustomHabitIcon)? onIconSelected;
  final EdgeInsets? margin;
  final Color? primaryColor;

  // Color list
  int get _rowCount => iconList.length % 4 == 0 ? iconList.length ~/ 4 : iconList.length ~/ 4 + 1;



  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: margin,
      padding: SizeHelper.boxPadding,
      child: Row(
        children: [
          /// Icon
          SvgPicture.asset(
            Assets.icon_picker,
            color: primaryColor ?? customColors.primary,
            // color: HexColor.fromHex(_selectedCustomHabitIcon?.color ?? ColorCodes.primary),
          ),

          /// Дүрс сонгох
          Expanded(
            child: CustomText(
              LocaleKeys.pickShape,
              fontWeight: FontWeight.w500,
              margin: EdgeInsets.only(left: 15.0),
            ),
          ),

          /// Color
          SvgPicture.asset(Assets.arrow_forward, color: customColors.iconGrey),
        ],
      ),
      onTap: () {
        showCustomDialog(
          context,
          isDismissible: true,
          child: CustomDialogBody(
            child: Column(
              children: [
                // Note: GridView статик өргөн өндөр тохируулж чаддаггүй учир ашиглах хэрэггүй
                for (int i = 0; i < _rowCount; i++) _rowItem(context, i),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rowItem(BuildContext context, int rowIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Col 1
          Expanded(child: _gridItem(context, iconList[rowIndex * 4])),

          SizedBox(width: 15.0),

          /// Col 2
          Expanded(
            child: (rowIndex * 4 + 1 < iconList.length) ? _gridItem(context, iconList[rowIndex * 4 + 1]) : Container(),
          ),

          SizedBox(width: 15.0),

          /// Col 3
          Expanded(
            child: (rowIndex * 4 + 2 < iconList.length) ? _gridItem(context, iconList[rowIndex * 4 + 2]) : Container(),
          ),

          SizedBox(width: 15.0),

          /// Col 4
          Expanded(
            child: (rowIndex * 4 + 3 < iconList.length) ? _gridItem(context, iconList[rowIndex * 4 + 3]) : Container(),
          ),
        ],
      ),
    );
  }

  Widget _gridItem(BuildContext context, CustomHabitIcon customHabitIcon) {
    return Func.isNotEmpty(customHabitIcon.link)
        ? InkWell(
            onTap: () {
              if (onIconSelected != null) onIconSelected!(customHabitIcon);
              Navigator.pop(context);
            },
            child: Container(
              width: 65.0,
              height: 65.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                border: Border.all(
                  width: selectedIcon?.link == customHabitIcon.link ? 0.0 : SizeHelper.borderWidth,
                  color: customColors.roseWhiteBorder,
                ),
                color: selectedIcon?.link == customHabitIcon.link
                    ? customColors.greyBackground
                    : customColors.secondaryBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(),
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: customHabitIcon.link!,
                      fit: BoxFit.fitWidth,
                      width: 18.0,
                      height: 18.0,
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) => Container(),
                      color: primaryColor ?? customColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
