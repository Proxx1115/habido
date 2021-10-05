import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/time_picker.dart';
import 'reminder_bloc.dart';

class ReminderWidget extends StatefulWidget {
  final ReminderBloc reminderBloc;
  final Color? primaryColor;
  final EdgeInsets? margin;

  const ReminderWidget({Key? key, required this.reminderBloc, this.primaryColor, this.margin}) : super(key: key);

  @override
  _ReminderWidgetState createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.reminderBloc,
      child: BlocListener<ReminderBloc, ReminderState>(
        listener: _blocListener,
        child: BlocBuilder<ReminderBloc, ReminderState>(
          builder: (context, state) {
            return StadiumContainer(
              margin: widget.margin,
              child: Column(
                children: [
                  /// Header
                  _headerSwitch(),

                  if (widget.reminderBloc.switchValue) HorizontalLine(margin: EdgeInsets.symmetric(horizontal: 15.0)),

                  /// Body
                  if (widget.reminderBloc.switchValue)
                    for (var el in widget.reminderBloc.timeOfDayList) _reminderItem(el),

                  /// Button add
                  if (widget.reminderBloc.switchValue) _buttonAdd(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ReminderState state) {
    if (state is AddReminderSuccessState) {
      print('AddReminderSuccessState');
    } else if (state is ReminderSwitchChangedState) {
      if (state.value && widget.reminderBloc.timeOfDayList.isEmpty) {
        _onPressedButtonAdd();
      }
    }
  }

  Widget _headerSwitch() {
    return CustomSwitch(
      margin: EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 0.0),
      value: widget.reminderBloc.timeOfDayList.isNotEmpty,
      leadingAsset: Assets.bell,
      leadingAssetColor: widget.primaryColor,
      activeText: LocaleKeys.remindHabit,
      activeColor: widget.primaryColor,
      onChanged: (value) {
        widget.reminderBloc.add(ReminderSwitchChangedEvent(value));
      },
    );
  }

  Widget _reminderItem(TimeOfDay timeOfDay) {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      padding: EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: SizeHelper.borderWidth, color: customColors.primaryBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Prefix icon
          SvgPicture.asset(Assets.clock20, color: widget.primaryColor ?? customColors.primary),

          /// Time
          Expanded(
            child: CustomText(
              '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute}',
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              fontWeight: FontWeight.w500,
            ),
          ),

          /// Clear button
          CircleButton(
            asset: Assets.clear,
            backgroundColor: widget.primaryColor,
            onPressed: () {
              widget.reminderBloc.add(RemoveReminderEvent(timeOfDay));
            },
          ),
        ],
      ),
    );
  }

  Widget _buttonAdd() {
    return CustomButton(
      style: CustomButtonStyle.mini,
      text: LocaleKeys.addTime,
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      backgroundColor: widget.primaryColor,
      onPressed: _onPressedButtonAdd,
    );
  }

  void _onPressedButtonAdd() async {
    TimeOfDay? selectedTimeOfDay = await showCustomTimePicker(context, widget.primaryColor);
    if (selectedTimeOfDay != null) {
      widget.reminderBloc.add(AddReminderEvent(selectedTimeOfDay));
    }
  }
}
