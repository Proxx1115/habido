import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/text.dart';

class HabitItemWidget extends StatelessWidget {
  final Map data;
  final bool isActiveHabit;
  const HabitItemWidget({Key? key, required this.data, required this.isActiveHabit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // _navigateToHabitDetailRoute();
      },
      borderRadius: SizeHelper.startHabitItemRadius,
      child: Stack(children: [
        Container(
          height: 78.0,
          padding: EdgeInsets.fromLTRB(22.0, 12.0, 22.0, 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
            color: customColors.whiteBackground,
          ),
          child: Row(
            children: [
              /// Image
              // if (Func.isNotEmpty(data["leadingUrl"]))
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: CachedNetworkImage(
                  imageUrl: data["leadingUrl"]!,
                  color: HexColor.fromHex(data["leadingBackgroundColor"]),
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
                    CustomText(data["title"], fontSize: 15.0, fontWeight: FontWeight.w500),
                    SizedBox(height: 1.0),
                    CustomText(data["detail"], fontSize: 11.0),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        TagItemWidget(text: data["startDate"]),
                        Container(
                          height: 1,
                          width: 18.0,
                          color: customColors.primaryButtonDisabledContent,
                        ),
                        TagItemWidget(text: data["endDate"]),
                      ],
                    )
                  ],
                ),
              ),
              isActiveHabit
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: 33.0,
                      width: 33.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        border: Border.all(color: customColors.iconVikingGreen, width: 2),
                      ),
                      child: CustomText(
                        '100%',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: customColors.iconSeaGreen,
                        alignment: Alignment.center,
                      ))
            ],
          ),
        ),
        Positioned(right: 0, top: 0, child: dayInterval())
      ]),
    );
  }

  Widget dayInterval() {
    return Container(
      height: 20,
      constraints: BoxConstraints(
        minWidth: 105.0,
      ),
      decoration: BoxDecoration(
        color: customColors.greyBackground,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(SizeHelper.borderRadius),
          bottomLeft: Radius.circular(SizeHelper.borderRadius),
        ),
      ),
      child: CustomText(isActiveHabit ? 'Өдөр бүр' : "Амжилттай хэвшүүлсэн", fontSize: 11.0, alignment: Alignment.center),
    );
  }
}
