import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_progress_log.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/progress/habit_timer_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/audio_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/timer/timer_painter.dart';
import 'package:flutter/foundation.dart';

class CustomCountdownTimer extends StatefulWidget {
  final UserHabit userHabit;
  final Duration duration;
  final UserHabitProgressLog? userHabitProgressLog;
  final Duration additionalDuration;
  final Color? primaryColor;
  final bool visibleAddButton;
  final VoidCallback? callBack;
  final double timerSize;
  final String? music;

  const CustomCountdownTimer({
    Key? key,
    required this.userHabit,
    required this.duration,
    this.userHabitProgressLog,
    this.additionalDuration = const Duration(minutes: 5),
    this.primaryColor,
    this.visibleAddButton = false,
    this.callBack,
    this.timerSize = 265.0,
    this.music,
  }) : super(key: key);

  @override
  _CustomCountdownTimerState createState() => _CustomCountdownTimerState();
}

class _CustomCountdownTimerState extends State<CustomCountdownTimer> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  late Duration _duration;
  late Duration _additionalDuration;

  // Callback
  bool _callBack = true;

  // Audio
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    // Duration
    _duration = widget.duration;
    _additionalDuration = widget.additionalDuration;

    // Animation
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      value: 1,
    )..addStatusListener((AnimationStatus status) {
        print(status);
        if (status == AnimationStatus.reverse) {
          _callBack = true;
          print('callback: $_callBack');
        } else if (status == AnimationStatus.dismissed) {
          if (_callBack && widget.callBack != null) {
            // Callback
            widget.callBack!();

            // Alarm
            AudioManager.playAsset(AudioAsset.well_done);

            // Audio
            _audioPlayer?.stop();
            _printAudioState();
          }
        }
      });

    // Spent duration
    if (widget.userHabitProgressLog != null && Func.isNotEmpty(widget.userHabitProgressLog!.status)) {
      if (widget.userHabitProgressLog!.status! == UserHabitProgressLogStatus.Finished) {
        /// Finished
        _animationController.value = 0.0;
      } else {
        /// Not finished
        var spentDuration = Duration(seconds: widget.userHabitProgressLog!.spentTime ?? 0);

        // Check add time
        if (widget.userHabitProgressLog!.addTime != null) {
          _duration += Duration(seconds: widget.userHabitProgressLog!.addTime!);
          _animationController.duration = _duration;
        }

        // Set current animation value
        Duration currentDuration = _duration - spentDuration;
        _animationController.value = currentDuration.inSeconds / _duration.inSeconds;

        // Resume progress
        if (widget.userHabitProgressLog!.status == UserHabitProgressLogStatus.Play) {
          _onPressedPlay();
          WidgetsBinding.instance?.addPostFrameCallback((_) => () {
                setState(() {
                  print('refresh screen for pause button');
                });
              });
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userHabitBloc,
      child: BlocListener<UserHabitBloc, UserHabitState>(
        listener: (context, state) {
          //
        },
        child: BlocBuilder<UserHabitBloc, UserHabitState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                /// Timer widget
                _stopwatch(),

                SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// Add button
                    if (widget.visibleAddButton)
                      ButtonStadium(
                        asset: Assets.add_circle,
                        iconColor: widget.primaryColor ?? customColors.primary,
                        onPressed: _onPressedAdd,
                        margin: EdgeInsets.only(right: 15.0),
                      ),

                    /// Play button
                    ButtonStadium(
                      asset: _animationController.isAnimating ? Assets.pause : Assets.play,
                      iconColor: widget.primaryColor ?? customColors.primary,
                      onPressed: _onPressedPlayPause,
                    ),

                    SizedBox(width: 15.0),

                    /// Reset button
                    ButtonStadium(
                      asset: Assets.reset,
                      iconColor: widget.primaryColor ?? customColors.primary,
                      onPressed: _onPressedReset,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _stopwatch() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        /// Cursor
        Container(
          height: widget.timerSize,
          width: widget.timerSize,
          decoration: BoxDecoration(shape: BoxShape.circle, color: customColors.whiteBackground),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: TimerPainter(
                  animation: _animationController,
                  borderColor: customColors.whiteBackground,
                  cursorColor: widget.primaryColor ?? customColors.primary,
                ),
              );
            },
          ),
        ),

        /// Timer
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, Widget? child) {
                return Text(
                  _timeString(),
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }

  String _timeString() {
    Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;
    String res = '';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(currentDuration.inHours);
    String minutes = twoDigits(currentDuration.inMinutes.remainder(60));
    String seconds = twoDigits(currentDuration.inSeconds.remainder(60));

    if (currentDuration.inHours > 0) {
      res = '$hours:$minutes:$seconds';
    } else {
      res = '$minutes:$seconds';
    }

    return res;
  }

  _onPressedAdd() {
    setState(() {
      // Temp status
      bool wasAnimating = _animationController.isAnimating;

      // Stop animation
      _animationController.stop();

      // Current duration
      Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;

      // New duration
      Duration newDuration = currentDuration + _additionalDuration;
      if (newDuration > _duration) {
        // Calculation
        // 1	                  20 + 1
        // k = 20.5 / 21        19.5 + 1

        // Replace current duration
        _duration += _additionalDuration;
        _animationController.duration = _duration;
      } else {
        // Calculation
        // 1	                  20
        // k = 19.5 / 20		    18.5 + 1
      }

      // Set animation value
      _animationController.value = newDuration.inSeconds / _duration.inSeconds;

      // Resume animation
      if (wasAnimating) {
        _animationController.reverse(
          from: _animationController.value == 0.0 ? 1.0 : _animationController.value,
        );
      }

      // Logging
      HabitTimerHelper.logAdd(widget.userHabit.userHabitId, _additionalDuration.inSeconds);
    });
  }

  _onPressedPlayPause() {
    setState(() {
      if (_animationController.isAnimating) {
        _onPressedPause();
      } else {
        _onPressedPlay();
      }
    });
  }

  _onPressedPlay() {
    // Animation
    _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);

    // Audio
    if (_audioPlayer?.state == PlayerState.PAUSED) {
      _audioPlayer?.resume();
      _printAudioState();
    } else {
      if (Func.isNotEmpty(widget.music)) {
        // Init audio player
        _audioPlayer = AudioPlayer();

        // Play
        _audioPlayer?.play(widget.music!, isLocal: false);
        _printAudioState();
      }
    }

    // Logging
    Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;
    int spentTime = (_duration - currentDuration).inSeconds;
    HabitTimerHelper.logPlay(widget.userHabit.userHabitId, spentTime);
  }

  _onPressedPause() {
    // Animation
    _animationController.stop();

    // Audio
    _audioPlayer?.pause();
    _printAudioState();

    // Logging
    Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;
    int spentTime = (_duration - currentDuration).inSeconds;
    HabitTimerHelper.logPause(widget.userHabit.userHabitId, spentTime);
  }

  _onPressedReset() {
    setState(() {
      // Callback
      _callBack = false;
      print('callback: $_callBack');

      // Animation
      _animationController.reset();
      _duration = widget.duration;
      _animationController.duration = _duration;
      _animationController.value = 1.0;

      // Audio
      _audioPlayer?.stop();
      _printAudioState();

      // Logging
      HabitTimerHelper.logReset(widget.userHabit.userHabitId);
    });
  }

  _printAudioState() {
    Future.delayed(Duration(milliseconds: 1000), () {
      print(_audioPlayer?.state);
    });
  }
}
