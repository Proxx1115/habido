import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/ui/habit_new/habit_item_widget.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class HistoryHabitList extends StatelessWidget {
  const HistoryHabitList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List _historyHabitList = [
      {
        "day": "Өнөөдөр",
        "leadingUrl": "https://i.stack.imgur.com/ILTQq.png",
        "leadingBackgroundColor": "#cccccc",
        "title": "Дугуй унах",
        "time": "15:00",
        "status": "Гүйцэтгэсэн",
      },
      // {
      //   "day": "Өнөөдөр",
      //   "leadingUrl": "https://i.stack.imgur.com/ILTQq.png",
      //   "leadingBackgroundColor": "#cccccc",
      //   "title": "Дугуй унах",
      //   "time": "15:00",
      //   "status": "Гүйцэтгэсэн",
      // },
      // {
      //   "day": "Өнөөдөр",
      //   "leadingUrl": "https://i.stack.imgur.com/ILTQq.png",
      //   "leadingBackgroundColor": "#cccccc",
      //   "title": "Дугуй унах",
      //   "time": "15:00",
      //   "status": "Гүйцэтгэсэн",
      // }
    ];
    return ListView.builder(
      itemBuilder: (context, index) => _historyItem(context, _historyHabitList[index], index == 0, index == _historyHabitList.length - 1),
      // itemExtent: 90.0,

      itemCount: _historyHabitList.length,
    );
  }

  Widget _historyItem(context, data, isStart, isEnd) {
    return InkWell(
      onTap: () {
        // _navigateToHabitDetailRoute();
      },
      borderRadius: SizeHelper.startHabitItemRadius,
      child: Stack(children: [
        Container(
          height: 52.0,
          padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 8.0),
          decoration: BoxDecoration(
            borderRadius: isStart
                ? BorderRadius.only(
                    topRight: Radius.circular(SizeHelper.borderRadius),
                    topLeft: Radius.circular(SizeHelper.borderRadius),
                  )
                : isEnd
                    ? BorderRadius.only(
                        bottomRight: Radius.circular(SizeHelper.borderRadius),
                        bottomLeft: Radius.circular(SizeHelper.borderRadius),
                      )
                    : null,
            color: customColors.whiteBackground,
          ),
          child: Row(
            children: [
              /// Image
              // if (Func.isNotEmpty(data["leadingUrl"]))
              Container(
                margin: EdgeInsets.only(right: 15.0),
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
                child: Container(
                  child: Column(
                    children: [
                      CustomText(data["title"], fontSize: 15.0, fontWeight: FontWeight.w500),
                      SizedBox(height: 2.0),
                      CustomText(
                        data["time"],
                        fontSize: 11.0,
                        color: customColors.greyText,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    Assets.add,
                    color: customColors.iconSeaGreen,
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  CustomText(
                    data["status"],
                    fontSize: 11.0,
                    color: customColors.greyText,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 40.0 - 61.0,
              color: customColors.primaryBorder,
            ))
      ]),
    );
  }
}
