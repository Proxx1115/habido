import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/progress/habit_progress_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
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
  final _habitProgressBloc = HabitProgressBloc();
  Color _primaryColor = customColors.primary;
  Color _backgroundColor = customColors.primaryBackground;

  @override
  void initState() {
    if (widget.userHabit.habit?.color != null) {
      _primaryColor = HexColor.fromHex(widget.userHabit.habit!.color!);
    }

    if (widget.userHabit.habit?.backgroundColor != null) {
      _backgroundColor = HexColor.fromHex(widget.userHabit.habit!.backgroundColor!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: widget.userHabit.name,
      backgroundColor: _backgroundColor,
      body: BlocProvider.value(
        value: _habitProgressBloc,
        child: BlocListener<HabitProgressBloc, HabitProgressState>(
          listener: _blocListener,
          child: Container(
            padding: SizeHelper.paddingScreen,
            child: Column(
              children: [
                CountdownTimer(
                  duration: Duration(seconds: 1200),
                ),

                /// Button хадгалах
                _buttonSave(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HabitProgressState state) {
    if (state is SaveUserHabitProgressSuccess) {
      BlocManager.userHabitBloc.add(RefreshDashboardUserHabits());
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _buttonSave() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: () {
        var request = SaveUserHabitProgressRequest();
        request.userHabitId = widget.userHabit.userHabitId;

        _habitProgressBloc.add(SaveUserHabitProgressEvent(request));
      },
    );
  }
}