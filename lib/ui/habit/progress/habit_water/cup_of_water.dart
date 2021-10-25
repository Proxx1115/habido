import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class CupOfWater extends StatefulWidget {
  final UserHabit userHabit;
  final Function(bool isFinished)? onChanged;
  final Color primaryColor;

  const CupOfWater({
    Key? key,
    required this.userHabit,
    this.onChanged,
    required this.primaryColor,
  }) : super(key: key);

  @override
  _CupOfWaterState createState() => _CupOfWaterState();
}

class _CupOfWaterState extends State<CupOfWater> {
  // Goal
  int? _goalValue;
  int _currentValue = 0;
  bool _isDynamic = false;

  @override
  void initState() {
    super.initState();

    if (Func.toInt(widget.userHabit.goalValue) > 0) {
      _goalValue = Func.toInt(widget.userHabit.goalValue);
    } else if ((widget.userHabit.habit?.goalSettings?.goalMax ?? 0) > 0) {
      _goalValue = Func.toInt(widget.userHabit.habit!.goalSettings!.goalMax!);
    }

    if (widget.userHabit.userHabitId != null) {
      _currentValue = Func.toInt(SharedPref.getHabitProgressValue(widget.userHabit.userHabitId!));
      _isDynamic = widget.userHabit.isDynamicHabit ?? false;

      if (_currentValue == _goalValue && widget.onChanged != null) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          widget.onChanged!(true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _goalValue != null
        ? Container(
            height: 265.0,
            width: 315.0,
            padding: EdgeInsets.fromLTRB(18.0, 25.0, 18.0, 25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: customColors.whiteBackground,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Subtract
                _button(
                  asset: Assets.subtract10,
                  onPressed: () {
                    if (_currentValue - 1 >= 0) {
                      setState(() {
                        _currentValue--;
                      });

                      _checkProgress();
                    }
                  },
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      /// Cup of water
                      _isDynamic == false ? Expanded(
                        child: SvgPicture.asset(Assets.cup_of_water, alignment: Alignment.topCenter),
                      )

                      : Container(
                        margin: EdgeInsets.only(top: 30.0),
                        // padding: EdgeInsets.all(20.0),
                        height: 140.0,
                        width: 140.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                          color: customColors.greyBackground,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[

                            CustomText(
                            '$_currentValue',
                            fontWeight: FontWeight.w500,
                            fontSize: 50.0,
                            color: widget.primaryColor,
                            textAlign: TextAlign.center,
                          ),

                          ]
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 19.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Current value
                            CustomText(
                              '$_currentValue',
                              fontWeight: FontWeight.w500,
                              color: widget.primaryColor,
                            ),

                            /// Goal value
                            CustomText(
                              ' / $_goalValue',
                              color: customColors.greyText,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Add
                _button(
                  asset: Assets.add10,
                  onPressed: () {
                    if (_currentValue + 1 <= _goalValue!) {
                      setState(() {
                        _currentValue++;
                      });

                      _checkProgress();
                    }
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _button({required String asset, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(17.0),
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
          color: customColors.greyBackground,
        ),
        child: SvgPicture.asset(asset, color: widget.primaryColor),
      ),
    );
  }

  void _checkProgress() {
    SharedPref.setHabitProgressValue(widget.userHabit.userHabitId, Func.toStr(_currentValue));

    if (widget.onChanged != null) {
      widget.onChanged!(_currentValue == _goalValue);
    }
  }
}
