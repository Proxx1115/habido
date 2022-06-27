import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/text.dart';

class SlidableHabitItemWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? leadingUrl;
  final Color? leadingBackgroundColor;
  final String text;
  final String subText;
  final List<String>? reminders;
  final int? processPercent;
  final VoidCallback? onPressedSkip;
  final VoidCallback? onPressedDetail;
  final VoidCallback? onPressedEdit;
  final double? delay;
  final bool isStart;
  final bool isEnd;

  final SlidableController _controller = SlidableController();

  SlidableHabitItemWidget({
    Key? key,
    this.onPressed,
    this.leadingUrl,
    this.leadingBackgroundColor,
    required this.text,
    required this.subText,
    this.reminders,
    this.processPercent,
    this.onPressedSkip,
    this.onPressedDetail,
    this.onPressedEdit,
    this.delay,
    required this.isStart,
    required this.isEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double caltulatedExtentRatio = 55 / (MediaQuery.of(context).size.width - (SizeHelper.margin * 2));
    return MoveInAnimation(
      duration: 400,
      delay: delay,
      child: Slidable(
        controller: _controller,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: caltulatedExtentRatio,
        child: InkWell(
          onTap: onPressed,
          borderRadius: isStart
              ? SizeHelper.startHabitItemRadius
              : isEnd
                  ? SizeHelper.endHabitItemRadius
                  : null,
          child: Container(
            height: 78.0,
            padding: EdgeInsets.fromLTRB(22.0, 12.0, 22.0, 12.0),
            decoration: BoxDecoration(
              borderRadius: isStart
                  ? SizeHelper.startHabitItemRadius
                  : isEnd
                      ? SizeHelper.endHabitItemRadius
                      : null,
              color: customColors.whiteBackground,
            ),
            child: Row(
              children: [
                /// Image
                if (Func.isNotEmpty(leadingUrl))
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    // padding: EdgeInsets.all(12.0),
                    child: CachedNetworkImage(
                      imageUrl: leadingUrl!,
                      color: leadingBackgroundColor,
                      height: 30.0,
                      width: 30.0,
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),

                /// Text
                Expanded(
                  child: Column(
                    children: [
                      CustomText(text, fontSize: 15.0, fontWeight: FontWeight.w500),
                      CustomText(subText, fontSize: 11.0),
                      SizedBox(height: 3.5),
                      if (reminders != null && reminders!.isNotEmpty)
                        Row(
                          children: [
                            for (var el in reminders!)
                              TagItemWidget(
                                text: el,
                                margin: EdgeInsets.only(right: 8.0),
                              )
                          ],
                        )
                    ],
                  ),
                ),

                /// Process Percent
                Text('${processPercent}%')
              ],
            ),
          ),
        ),
        secondaryActions: [
          /// Button skip
          if (onPressedSkip != null) _buttonSkip(context),

          // / Button detail
          if (onPressedEdit != null) _buttonDetail(context),

          // / Button edit
          if (onPressedEdit != null) _buttonEdit(context),
        ],
      ),
    );
  }

  Widget _buttonSkip(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPressedSkip != null) onPressedSkip!();
      },
      child: Container(
        height: double.infinity,
        width: 55.0,
        color: customColors.disabledBackground,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 7.0),
              child: SvgPicture.asset(Assets.skip),
            ),

            /// Text
            CustomText(
              LocaleKeys.skip,
              fontSize: 8.0,
              alignment: Alignment.center,
              color: customColors.whiteText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonDetail(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPressedDetail != null) onPressedDetail!();
      },
      child: Container(
        height: double.infinity,
        width: 55.0,
        color: customColors.blueBackground,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 7.0),
              child: SvgPicture.asset(Assets.detail),
            ),

            /// Text
            CustomText(
              LocaleKeys.detail,
              fontSize: 8.0,
              alignment: Alignment.center,
              color: customColors.whiteText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonEdit(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPressedEdit != null) onPressedEdit!();
      },
      borderRadius: isStart
          ? SizeHelper.startExtentItemRadius
          : isEnd
              ? SizeHelper.endExtentItemRadius
              : null,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: double.infinity,
        width: 55.0,
        decoration: BoxDecoration(
          color: customColors.yellowBackground,
          borderRadius: isStart
              ? SizeHelper.startExtentItemRadius
              : isEnd
                  ? SizeHelper.endExtentItemRadius
                  : null,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 7.0),
              child: SvgPicture.asset(Assets.edit24),
            ),

            /// Text
            CustomText(
              LocaleKeys.edit,
              fontSize: 8.0,
              alignment: Alignment.center,
              color: customColors.whiteText,
            ),
          ],
        ),
      ),
    );
  }
}
