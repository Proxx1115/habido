import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:pausable_timer/pausable_timer.dart';

import 'breath_countdown_timer.dart';

class HabitBreathRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitBreathRoute({Key? key, required this.userHabit}) : super(key: key);

  @override
  _HabitBreathRouteState createState() => _HabitBreathRouteState();
}

class _HabitBreathRouteState extends State<HabitBreathRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late UserHabit _userHabit;

  // Controller
  int _countdownSec = 36; // (4 + 4 + 4) * 3
  late PausableTimer timer;

  CountdownTimerController? _countdownTimerController;

  // late int _endTime;

  // Button
  bool _enabledButton = false;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

    // Timer
    // WidgetsBinding.instance?.addPostFrameCallback((_) => _startCountDown(_countdownSec));
    timer = PausableTimer(Duration(seconds: _countdownSec), () => print('Fired!'));

    super.initState();
  }

  @override
  void dispose() {
    // _countdownTimerController?.dispose();
    super.dispose();
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
              appBarTitle: _userHabit.name,
              appBarLeadingColor: _primaryColor,
              backgroundColor: _backgroundColor,
              loading: state is UserHabitProgressLoading,
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    Expanded(child: Container()),

                    BreathCountdownTimer(
                      duration: Duration(seconds: _countdownSec),
                      primaryColor: _primaryColor,
                      callBack: () {
                        print('finished');
                      },
                    ),

                    Expanded(child: Container()),

                    /// Button finish
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
    if (state is SaveUserHabitProgressSuccess) {
      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'habitProgressResponse': state.habitProgressResponse,
        'primaryColor': _primaryColor,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  // void _startCountDown(int sec) {
  //   setState(() {
  //     _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * sec;
  //     _countdownTimerController = CountdownTimerController(endTime: _endTime, onEnd: _onEndCountDown);
  //   });
  // }

  // void _onEndCountDown() {
  //   setState(() => _enabledButton = true);
  //
  //   _countdownTimerController.start();
  // }

  bool _isTimerRunning = false;

  void _onPressedPlayPause() {
    if (_isTimerRunning) {
      _isTimerRunning = false;
      timer.pause();
    } else {
      _isTimerRunning = true;
      timer.start();
    }
  }

  void _onPressedReset() {
    //
  }

  Widget _buttonFinish() {
    return CustomButton(
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: _enabledButton
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = widget.userHabit.userHabitId;

              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
