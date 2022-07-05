import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_progress_log.dart';
import 'package:habido_app/ui/habit/progress/habit_timer_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/audio_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/buttons.dart';

class TreeCountdownTimer extends StatefulWidget {
  final UserHabit userHabit;
  final Duration duration;
  final Duration additionalDuration;
  final UserHabitProgressLog? userHabitProgressLog;
  final Color? primaryColor;
  final bool visibleAddButton;
  final VoidCallback? callBack;
  final String? music;

  const TreeCountdownTimer({
    Key? key,
    required this.userHabit,
    required this.duration,
    this.additionalDuration = const Duration(minutes: 5),
    this.userHabitProgressLog,
    this.primaryColor,
    this.visibleAddButton = false,
    this.callBack,
    this.music,
  }) : super(key: key);

  @override
  _TreeCountdownTimerState createState() => _TreeCountdownTimerState();
}

class _TreeCountdownTimerState extends State<TreeCountdownTimer> with TickerProviderStateMixin {
  late Color _primaryColor;

  // Animation
  late AnimationController _animationController;
  late Duration _duration;
  late Duration _additionalDuration;

  // Reset
  bool _callBack = true;

  // Audio
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _primaryColor = widget.primaryColor ?? customColors.primary;

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
          WidgetsBinding.instance.addPostFrameCallback((_) => () {
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
                iconColor: _primaryColor,
                onPressed: _onPressedAdd,
                margin: EdgeInsets.only(right: 15.0),
              ),

            /// Play button
            ButtonStadium(
              asset: _animationController.isAnimating ? Assets.pause : Assets.play,
              iconColor: _primaryColor,
              onPressed: _onPressedPlayPause,
            ),

            SizedBox(width: 15.0),

            /// Reset button
            ButtonStadium(
              asset: Assets.reset,
              iconColor: _primaryColor,
              onPressed: _onPressedReset,
            ),
          ],
        )
      ],
    );
  }

  Widget _stopwatch() {
    return Container(
      height: 265.0,
      width: 265.0,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: customColors.whiteBackground),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Tree
              Expanded(
                child: _treeWidget(),
              ),

              SizedBox(height: 15.0),

              /// Time
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _timeString(),
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _treeWidget() {
    Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;

    if (currentDuration.inSeconds > (_duration.inSeconds * 0.66)) {
      return MoveInAnimation(
        isAxisHorizontal: false,
        child: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: SvgPicture.asset(Assets.tree1),
        ),
      );
    } else if (currentDuration.inSeconds > (_duration.inSeconds * 0.33)) {
      return MoveInAnimation(
        isAxisHorizontal: false,
        child: Container(
          padding: EdgeInsets.only(top: 40.0),
          child: SvgPicture.asset(Assets.tree2),
        ),
      );
    } else {
      return MoveInAnimation(
        isAxisHorizontal: false,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Image.asset(
            Assets.tree3_png,
            width: 95.0,
          ),
        ),
      );
    }
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

  // _onPressedPlayPause() {
  //   setState(() {
  //     if (_animationController.isAnimating) {
  //       _animationController.stop();
  //     } else {
  //       _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);
  //     }
  //   });
  // }

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

  // _onPressedReset() {
  //   setState(() {
  //     _callBack = false;
  //     print('callback: $_callBack');
  //
  //     _animationController.reset();
  //     _duration = widget.duration;
  //     _animationController.duration = _duration;
  //     _animationController.value = 1.0;
  //   });
  // }

  _printAudioState() {
    Future.delayed(Duration(milliseconds: 1000), () {
      print(_audioPlayer?.state);
    });
  }
}
