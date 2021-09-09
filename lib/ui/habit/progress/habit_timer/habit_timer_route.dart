import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

import 'countdown_timer.dart';

class HabitTimerRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitTimerRoute({Key? key, required this.userHabit}) : super(key: key);

  @override
  _HabitTimerRouteState createState() => _HabitTimerRouteState();
}

class _HabitTimerRouteState extends State<HabitTimerRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Timer
  Duration? _duration;

  @override
  void initState() {
    // UI
    _primaryColor = HabitHelper.getPrimaryColor(widget.userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(widget.userHabit);

    // Timer
    int? goalValue;
    if (Func.toInt(widget.userHabit.goalValue) > 0) {
      goalValue = Func.toInt(widget.userHabit.goalValue);
    } else if ((widget.userHabit.habit?.goalSettings?.goalMax ?? 0) > 0) {
      goalValue = Func.toInt(widget.userHabit.habit!.goalSettings!.goalMax!);
    }

    if (goalValue != null) {
      if (widget.userHabit.habit?.goalSettings?.toolType == ToolTypes.Minute) {
        _duration = Duration(minutes: goalValue);
      } else if (widget.userHabit.habit?.goalSettings?.toolType == ToolTypes.Hour) {
        _duration = Duration(hours: goalValue);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: widget.userHabit.name,
      appBarLeadingColor: _primaryColor,
      backgroundColor: _backgroundColor,
      body: BlocProvider.value(
        value: BlocManager.userHabitBloc,
        child: BlocListener<UserHabitBloc, UserHabitState>(
          listener: _blocListener,
          child: Container(
            padding: SizeHelper.paddingScreen,
            child: Column(
              children: [
                Expanded(child: Container()),

                /// Timer
                if (_duration != null)
                  CountdownTimer(
                    duration: _duration!,
                    primaryColor: _primaryColor,
                    // visibleAddButton: widget.userHabit.habit?.goalSettings?.goalIsExtendable ?? false,
                    visibleAddButton: false, // todo test
                  ),

                Expanded(child: Container()),

                /// Button хадгалах
                _buttonFinish(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is SaveUserHabitProgressSuccess) {
      BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'title': LocaleKeys.youDidIt,
        'primaryColor': _primaryColor,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _buttonFinish() {
    return CustomButton(
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: () {
        var request = SaveUserHabitProgressRequest();
        request.userHabitId = widget.userHabit.userHabitId;

        BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
      },
    );
  }
}
