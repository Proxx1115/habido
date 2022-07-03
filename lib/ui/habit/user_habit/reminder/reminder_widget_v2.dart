import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/switch_v2.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:habido_app/widgets/time_picker.dart';
import 'reminder_bloc.dart';

class ReminderWidgetV2 extends StatefulWidget {
  final ReminderBloc reminderBloc;
  final Color? primaryColor;
  final EdgeInsets? margin;

  const ReminderWidgetV2(
      {Key? key, required this.reminderBloc, this.primaryColor, this.margin})
      : super(key: key);

  @override
  _ReminderWidgetV2State createState() => _ReminderWidgetV2State();
}

class _ReminderWidgetV2State extends State<ReminderWidgetV2> {
  // Name
  final _aboutHabitController = TextEditingController();
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
                  HorizontalLine(),
                  _aboutHabitTextField(),
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

  Widget _aboutHabitTextField() {
    return CustomTextField(
      controller: _aboutHabitController,
      hintText: LocaleKeys.typeSomething,
      maxLength: 30,
      borderRadius: SizeHelper.borderRadiusOdd,
    );
  }

  Widget _headerSwitch() {
    return CustomSwitchV2(
      value: widget.reminderBloc.timeOfDayList.isNotEmpty,
      leadingAsset: Assets.bell,
      leadingAssetColor: widget.primaryColor,
      activeText: LocaleKeys.remindHabit,
      activeColor: widget.primaryColor,
      primaryColor: widget.primaryColor,
      activeAsset: Assets.dot,
      onChanged: (value) {
        widget.reminderBloc.add(ReminderSwitchChangedEvent(value));
      },
      reminderBloc: widget.reminderBloc,
    );
  }

  void _onPressedButtonAdd() async {
    TimeOfDay? selectedTimeOfDay =
        await showCustomTimePicker(context, widget.primaryColor);
    if (selectedTimeOfDay != null) {
      widget.reminderBloc.add(AddReminderEvent(selectedTimeOfDay));
    }
  }
}
