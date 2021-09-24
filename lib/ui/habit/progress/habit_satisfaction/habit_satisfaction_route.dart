import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/progress/habit_satisfaction/satisfaction_photo.dart';
import 'package:habido_app/ui/habit/progress/habit_satisfaction/satisfaction_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

/// Сэтгэл ханамж
class HabitSatisfactionRoute extends StatefulWidget {
  final UserHabit userHabit;
  final VoidCallback? callBack;

  const HabitSatisfactionRoute({
    Key? key,
    required this.userHabit,
    this.callBack,
  }) : super(key: key);

  @override
  _HabitSatisfactionRouteState createState() => _HabitSatisfactionRouteState();
}

class _HabitSatisfactionRouteState extends State<HabitSatisfactionRoute> {
// UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late UserHabit _userHabit;

  // Photo
  String? _base64Image;

  // Slider
  late int _sliderValue;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor1(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor1(_userHabit);

    // Slider
    _sliderValue = Func.toInt(Func.toInt(_userHabit.habit!.goalSettings!.goalMax) / 2);
    print(_sliderValue);

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
              appBarTitle: _userHabit.name,
              appBarLeadingColor: _primaryColor,
              backgroundColor: _backgroundColor,
              loading: state is UserHabitProgressLoading,
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: SatisfactionPhoto(
                                  primaryColor: _primaryColor,
                                  onImageCaptured: (value) {
                                    setState(() {
                                      _base64Image = value;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: SatisfactionSlider(
                                  userHabit: _userHabit,
                                  margin: EdgeInsets.only(top: 35.0),
                                  text: LocaleKeys.howAreYouFeeling,
                                  onChanged: (value) {
                                    print(value);
                                    _sliderValue = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

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
        'callback': widget.callBack,
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
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: (_base64Image != null && _sliderValue != null)
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = widget.userHabit.userHabitId;
              request.photoBase64 = _base64Image;
              request.value = Func.toStr(_sliderValue);

              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
