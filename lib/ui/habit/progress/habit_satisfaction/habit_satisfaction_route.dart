import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/progress/habit_satisfaction/satisfaction_photo.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

/// Сэтгэл ханамж
class HabitSatisfactionRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitSatisfactionRoute({Key? key, required this.userHabit}) : super(key: key);

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

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

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
                    Expanded(child: Container()),

                    SatisfactionPhoto(primaryColor: _primaryColor),

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
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: _base64Image != null
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = widget.userHabit.userHabitId;
              request.photoBase64 = _base64Image;

              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
