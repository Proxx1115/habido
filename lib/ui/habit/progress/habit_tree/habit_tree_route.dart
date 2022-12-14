import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_progress_log.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'tree_countdown_timer.dart';

class HabitTreeRoute extends StatefulWidget {
  final UserHabit userHabit;
  final VoidCallback? callBack;

  const HabitTreeRoute({
    Key? key,
    required this.userHabit,
    this.callBack,
  }) : super(key: key);

  @override
  _HabitTreeRouteState createState() => _HabitTreeRouteState();
}

class _HabitTreeRouteState extends State<HabitTreeRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Timer
  Duration? _duration;
  UserHabitProgressLog? _userHabitProgressLog;

  // Button
  bool _enabledButton = false;

  @override
  void initState() {
    // UI
    _primaryColor = HabitHelper.getPrimaryColor1(widget.userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor1(widget.userHabit);

    BlocManager.userHabitBloc
        .add(GetUserHabitProgressLogEvent(widget.userHabit.userHabitId ?? 0, widget.userHabit.planDate ?? DateTime.now().toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userHabitBloc,
      child: BlocListener<UserHabitBloc, UserHabitState>(
        listener: _blocListener,
        child: BlocBuilder<UserHabitBloc, UserHabitState>(
          builder: (context, state) {
            return CustomScaffold(
              appBarTitle: widget.userHabit.name,
              appBarLeadingColor: _primaryColor,
              backgroundColor: _backgroundColor,
              loading: state is UserHabitProgressLoading,
              child: Container(
                padding: SizeHelper.screenPadding,
                child: Column(
                  children: [
                    Expanded(child: Container()),

                    /// Timer
                    if (_duration != null)
                      TreeCountdownTimer(
                        userHabit: widget.userHabit,
                        userHabitProgressLog: _userHabitProgressLog,
                        duration: _duration!,
                        primaryColor: _primaryColor,
                        visibleAddButton: widget.userHabit.habit?.goalSettings?.goalIsExtendable ?? false,
                        music: widget.userHabit.habit?.goalSettings?.toolContent?.music,
                        callBack: () {
                          setState(() {
                            _enabledButton = true;
                          });
                        },
                      ),

                    Expanded(child: Container()),

                    /// Button ????????????????
                    _buttonFinish(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is GetUserHabitProgressLogSuccess) {
      // Spent time
      if ((state.habitProgressLog.planLogId ?? 0) > 0) {
        _userHabitProgressLog = state.habitProgressLog;
      }

      // Init
      _init();
    } else if (state is SaveUserHabitProgressSuccess) {
      Navigator.pushReplacementNamed(context, Routes.habitSuccessNew, arguments: {
        'callback': widget.callBack,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  _init() {
    // Timer
    int? goalValue;
    if (Func.toInt(widget.userHabit.goalValue) > 0) {
      goalValue = Func.toInt(widget.userHabit.goalValue);
    } else if ((widget.userHabit.habit?.goalSettings?.goalMax ?? 0) > 0) {
      goalValue = Func.toInt(widget.userHabit.habit!.goalSettings!.goalMax!);
    }

    if (goalValue != null) {
      if (widget.userHabit.habit?.goalSettings?.toolType == ToolType.Minute) {
        _duration = Duration(minutes: goalValue);
      } else if (widget.userHabit.habit?.goalSettings?.toolType == ToolType.Hour) {
        _duration = Duration(hours: goalValue);
      }
    }

    // Is button finish enabled
    if (_userHabitProgressLog != null && _duration != null) {
      var spentDuration = Duration(seconds: _userHabitProgressLog!.spentTime ?? 0);
      if (spentDuration < _duration!) {
        // In progress
        _enabledButton = false;
      } else {
        // Finished
        _enabledButton = true;
      }
    }
  }

  Widget _buttonFinish() {
    return CustomButton(
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: _enabledButton
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = widget.userHabit.userHabitId;
              request.planDate = widget.userHabit.planDate ?? DateTime.now().toString();
              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
