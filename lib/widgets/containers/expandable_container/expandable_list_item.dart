import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class ExpandableListItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? leadingImageUrl;
  final Color? leadingBackgroundColor;
  final String text;
  final VoidCallback? onPressedSkip;
  final VoidCallback? onPressedEdit;

  final SlidableController _controller = SlidableController();

  ExpandableListItem({
    Key? key,
    this.onPressed,
    this.leadingImageUrl,
    this.leadingBackgroundColor,
    required this.text,
    this.onPressedSkip,
    this.onPressedEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: _controller,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      // closeOnTap: true,

      secondaryActions: <Widget>[
        /// Button skip
        if (onPressedSkip != null)
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: ButtonStadium(
              asset: Assets.skip,
              margin: EdgeInsets.only(left: 15.0),
              size: SizeHelper.listItemHeight70,
              backgroundColor: customColors.blueBackground,
              iconColor: customColors.iconWhite,
              enabled: false,
            ),
            onTap: () {
              if (onPressedSkip != null) onPressedSkip!();
            },
          ),

        /// Button edit
        if (onPressedEdit != null)
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: ButtonStadium(
              asset: Assets.edit24,
              margin: EdgeInsets.only(left: 15.0),
              size: SizeHelper.listItemHeight70,
              backgroundColor: customColors.yellowBackground,
              iconColor: customColors.iconWhite,
              enabled: false,
            ),
            onTap: () {
              if (onPressedEdit != null) onPressedEdit!();
            },
          ),
      ],
      child: InkWell(
        onTap: onPressed,
        borderRadius: SizeHelper.borderRadiusOdd,
        child: Container(
          height: SizeHelper.listItemHeight70,
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 15.0),
          decoration: BoxDecoration(
            borderRadius: SizeHelper.borderRadiusOdd,
            color: customColors.secondaryBackground,
          ),
          child: Row(
            children: [
              /// Image
              if (Func.isNotEmpty(leadingImageUrl))
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
                    imageUrl: leadingImageUrl!,
                    fit: BoxFit.fitWidth,
                    width: 20.0,
                    height: 20.0,
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),

              /// Text
              Expanded(
                child: CustomText(text, fontWeight: FontWeight.w500),
              ),

              /// Arrow
              SvgPicture.asset(Assets.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
