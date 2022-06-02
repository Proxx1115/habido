import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class HorizontalHabitCard extends StatelessWidget {
  final Habit habit;
  final EdgeInsets? margin;
  final VoidCallback? callback;
  final Color? backgroundColor;

  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(SizeHelper.borderRadius));
  final double _height = 140.0;

  HorizontalHabitCard({
    Key? key,
    required this.habit,
    this.margin,
    this.callback,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: InkWell(
        onTap: () {
          if (callback != null) callback!();

          Navigator.pushNamed(context, Routes.userHabit, arguments: {
            'habit': habit,
          });
        },
        borderRadius: _borderRadius,
        child: Hero(
          tag: Func.toStr(habit.habitId),
          child: Container(
            margin: margin,
            height: _height,
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              color: backgroundColor ?? customColors.whiteBackground,
            ),
            child: Row(
              children: [
                /// Cover image
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                  child: CachedNetworkImage(
                    imageUrl: habit.photo ?? '',
                    fit: BoxFit.fitHeight,
                    height: _height,
                    // width: MediaQuery.of(context).size.width * 0.3,
                    width: 115.0,
                    placeholder: (context, url) => CustomLoader(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),

                // 174
                // flex: 35, // 105/289
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Column(
                      children: [
                        /// Title
                        CustomText(
                          habit.name,
                          fontWeight: FontWeight.w500,
                          maxLines: 3,
                        ),

                        /// Body
                        Expanded(
                          child: CustomText("Хугацаа - 12 сар", margin: EdgeInsets.only(top: 15.0), maxLines: 2),
                        ),

                        /// Time
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              /// Clock icon
                              Container(
                                height: 24.0,
                                width: 24.0,
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.bottomLeft,
                                child: SvgPicture.asset(Assets.clock),
                              ),

                              /// Read time
                              Expanded(
                                child: CustomText(
                                  '24:00',
                                  margin: EdgeInsets.only(left: 7.0),
                                  alignment: Alignment.bottomLeft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
