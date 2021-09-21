import 'package:flutter/material.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class SatisfactionSlider extends StatefulWidget {
  final UserHabit userHabit;
  final String text;
  final Function(int)? onChanged;
  final EdgeInsets? margin;

  const SatisfactionSlider({
    Key? key,
    required this.userHabit,
    required this.text,
    this.onChanged,
    this.margin,
  }) : super(key: key);

  @override
  _SatisfactionSliderState createState() => _SatisfactionSliderState();
}

class _SatisfactionSliderState extends State<SatisfactionSlider> {
  // UI
  late Color _primaryColor;

  // Data
  late UserHabit _userHabit;

  // Slider
  int? _value;
  int? _minValue;
  int? _maxValue;
  int? _step;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);

    if (_userHabit.habit?.goalSettings != null && _userHabit.habit?.goalSettings!.toolType != null) {
      _minValue = Func.toInt(_userHabit.habit!.goalSettings!.goalMin);
      _maxValue = Func.toInt(_userHabit.habit!.goalSettings!.goalMax);
      _value = Func.toInt(Func.toInt(_userHabit.habit!.goalSettings!.goalMax) / 2);
      _step = Func.toInt(_userHabit.habit!.goalSettings!.goalStep);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: widget.margin,
      padding: SizeHelper.boxPadding,
      child: Column(
        children: [
          /// Text
          CustomText(widget.text, alignment: Alignment.center),

          /// Divider
          HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Slider
          _slider(),
        ],
      ),
    );
  }

  Widget _slider() {
    return (_value != null && _minValue != null && _maxValue != null && _maxValue! > _minValue! && _step != null)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Үнэлгээ
                  Expanded(
                    child: CustomText(widget.text, color: customColors.secondaryText),
                  ),

                  /// Тааламжтай
                  CustomText(LocaleKeys.pleasing, fontWeight: FontWeight.w500),
                ],
              ),
              Row(
                children: [
                  /// Decrease
                  CircleButton(
                    asset: Assets.negative,
                    contentColor: _primaryColor,
                    backgroundColor: customColors.greyBackground,
                    onPressed: () {
                      setState(() {
                        _value = ((_value! - 1) >= _minValue!) ? (_value! - 1) : _value!;
                        if (widget.onChanged != null) widget.onChanged!(Func.toInt(_value));
                      });
                    },
                  ),

                  Expanded(
                    child: Slider(
                      value: Func.toDouble(_value),
                      min: Func.toDouble(_minValue),
                      max: Func.toDouble(_maxValue),
                      divisions: Func.toInt((_maxValue! - _minValue!) / _step!),
                      activeColor: _primaryColor,
                      onChanged: (double value) {
                        setState(() {
                          _value = Func.toInt(value);
                          if (widget.onChanged != null) widget.onChanged!(_value!);
                        });
                      },
                    ),
                  ),

                  /// Increase
                  CircleButton(
                    asset: Assets.positive,
                    contentColor: _primaryColor,
                    backgroundColor: customColors.greyBackground,
                    onPressed: () {
                      setState(() {
                        _value = ((_value! + 1) <= _maxValue!) ? (_value! + 1) : _value!;
                        if (widget.onChanged != null) widget.onChanged!(Func.toInt(_value));
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        : Container();
  }
}
