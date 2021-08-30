import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/plans.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/ui/habit/habit/habit_bloc.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class HabitRoute extends StatefulWidget {
  final String? title;
  final Habit? habit;

  const HabitRoute({Key? key, this.title, this.habit}) : super(key: key);

  @override
  _HabitRouteState createState() => _HabitRouteState();
}

class _HabitRouteState extends State<HabitRoute> {
  // UI
  final HabitBloc _habitBloc = HabitBloc();

  // Name
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    // Name
    if (widget.habit?.name != null) {
      _nameController.text = widget.habit!.name!;
    }

    super.initState();
  }

  @override
  void dispose() {
    _habitBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: widget.title != null ? widget.title : LocaleKeys.habit,
      body: SingleChildScrollView(
        child: Container(
          padding: SizeHelper.paddingScreen,
          child: BlocProvider.value(
            value: _habitBloc,
            child: BlocListener<HabitBloc, HabitState>(
              listener: _blocListener,
              child: BlocBuilder<HabitBloc, HabitState>(builder: (context, state) {
                return Column(
                  children: [
                    /// Name
                    _nameTextField(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HabitState state) {
    //
  }

  Widget _nameTextField() {
    return CustomTextField(
      controller: _nameController,
      maxLength: 30,
    );
  }

  _onPressedButtonSave() {
    // var request = UserHabit()
    //   // ..userHabitId = 0
    //   // ..userId = 1
    //   ..habitId = widget.habit.habitId
    //   ..name = 'Явган алхах'
    //   ..startDate = '' //everyday
    //   ..endDate = '' //everyday
    //   ..isReminder = true
    //   ..repeatName = PlanTerm.Daily //'Daily' //'Weekly', 'Monthly'
    //   ..hasGoal = false
    //   ..goalValue = ''
    //   ..note = ''
    //   ..userNote = ''
    //   ..status = ''
    //   ..userHabitReminders = [
    //     UserHabitReminders()
    //       // ..reminderId;
    //       // ..userHabitId;
    //       ..time = 1 // minutaar
    //   ]
    //   ..plans = [
    // monthly
    // Plans()
    //   ..planDate = '2021-08-27'
    //   ..term = PlanTerm.Monthly,
    // Plans()
    //   ..weekDay = '2021-08-27'
    //   ..term = PlanTerm.Monthly,
    //
    // // weekly
    // Plans()
    //   ..weekDay = WeekDays.Mon
    //   ..term = PlanTerm.Weekly,
    // Plans()
    //   ..weekDay = WeekDays.Fri
    //   ..term = PlanTerm.Week,

    //everyday null
    // ];
  }
}
