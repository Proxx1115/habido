import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class ExpandableListItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? leadingUrl;
  final Color? leadingColor;
  final Color? leadingBackgroundColor;
  final String text;
  final String? suffixAsset;
  final Color? suffixColor;
  final VoidCallback? onPressedSkip;
  final VoidCallback? onPressedEdit;
  final double? delay;

  final SlidableController _controller = SlidableController();

  ExpandableListItem({
    Key? key,
    this.onPressed,
    this.leadingUrl,
    this.leadingColor,
    this.leadingBackgroundColor,
    required this.text,
    this.suffixAsset,
    this.suffixColor,
    this.onPressedSkip,
    this.onPressedEdit,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoveInAnimation(
      duration: 400,
      delay: delay,
      child: Slidable(
        controller: _controller,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: InkWell(
          onTap: onPressed,
          borderRadius: SizeHelper.borderRadiusOdd,
          child: Container(
            height: SizeHelper.listItemHeight70,
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 15.0),
            decoration: BoxDecoration(
              borderRadius: SizeHelper.borderRadiusOdd,
              color: customColors.whiteBackground,
            ),
            child: Row(
              children: [
                /// Image
                if (Func.isNotEmpty(leadingUrl))
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
                    padding: EdgeInsets.all(10.0),
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
                      color: leadingBackgroundColor ?? customColors.greyBackground,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: leadingUrl!,
                      color: leadingColor,
                      fit: BoxFit.fitWidth,
                      width: 20.0,
                      height: 20.0,
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),

                /// Text
                Expanded(
                  child: CustomText(text, fontWeight: FontWeight.w500, maxLines: 2),
                ),

                /// Arrow
                SvgPicture.asset(suffixAsset ?? Assets.arrow_forward, color: suffixColor ?? customColors.iconGrey),
              ],
            ),
          ),
        ),
        secondaryActions: [
          /// Button skip
          if (onPressedSkip != null) _buttonSkip(context),

          /// Button edit
          if (onPressedEdit != null) _buttonEdit(context),
        ],
      ),
    );
  }

  Widget _buttonSkip(BuildContext context) {
    return IconSlideAction(
      color: Colors.transparent,
      iconWidget: ButtonStadium(
        asset: Assets.skip,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Icon
            SvgPicture.asset(
              Assets.skip,
              fit: BoxFit.scaleDown,
              color: customColors.iconWhite,
            ),

            /// Text
            CustomText(
              LocaleKeys.skip,
              fontSize: 9.0,
              alignment: Alignment.center,
              color: customColors.whiteText,
              fontWeight: FontWeight.w500,
              margin: EdgeInsets.only(top: 5.0),
             ),
          ],
        ),
        size: SizeHelper.listItemHeight70,
        margin: EdgeInsets.zero,
        backgroundColor: customColors.blueBackground,
        iconColor: customColors.iconWhite,
        enabled: false,
      ),
      onTap: () {
        if (onPressedSkip != null) onPressedSkip!();
      },
    );
  }

  Widget _buttonEdit(BuildContext context) {
    return IconSlideAction(
      color: Colors.transparent,
      iconWidget: ButtonStadium(
        asset: Assets.edit24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Icon
            SvgPicture.asset(
              Assets.edit24,
              fit: BoxFit.scaleDown,
              color: customColors.iconWhite,
            ),

            /// Text
            CustomText(
              LocaleKeys.edit,
              fontSize: 9.0,
              alignment: Alignment.center,
              color: customColors.whiteText,
              fontWeight: FontWeight.w500,
              margin: EdgeInsets.only(top: 5.0),
            ),
          ],
        ),
        size: SizeHelper.listItemHeight70,
        backgroundColor: customColors.yellowBackground,
        iconColor: customColors.iconWhite,
        enabled: false,
      ),
      onTap: () {
        if (onPressedEdit != null) onPressedEdit!();
      },
    );
  }
}
