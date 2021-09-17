import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
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

class HabitFinanceStatementRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitFinanceStatementRoute({Key? key, required this.userHabit}) : super(key: key);

  @override
  _HabitFinanceStatementRouteState createState() => _HabitFinanceStatementRouteState();
}

class _HabitFinanceStatementRouteState extends State<HabitFinanceStatementRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late UserHabit _userHabit;

  // Total amount
  String _totalAmountTitle = LocaleKeys.total;
  double _totalAmount = 0.0;

  // Progress
  List<HabitProgress>? _habitProgressList;

  // Button
  bool _enabledButtonFinish = false;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

    // Total amount
    if (_userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
      _totalAmountTitle = LocaleKeys.totalSavings;
      _totalAmount = Func.toDouble(_userHabit.goalValue);
    } else if (_userHabit.habit?.goalSettings?.toolType == ToolType.Expense) {
      _totalAmountTitle = LocaleKeys.totalExpense;
    }

    // Get progress
    var request = HabitProgressListByDateRequest()
      ..dateTime = Func.toDateStr(DateTime.now())
      ..userHabitId = widget.userHabit.userHabitId;
    BlocManager.userHabitBloc.add(GetHabitProgressListByDateEvent(request));

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
                    //

                    /// Progress list
                    Expanded(
                      child: _progressListWidget(),
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
    if (state is GetHabitProgressListByDateSuccess) {
      _habitProgressList = state.habitProgressList;
    } else if (state is GetHabitProgressListByDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is SaveUserHabitProgressSuccess) {
      BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

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

  Widget _progressListWidget() {
    return Container();
  }

  Widget _buttonFinish() {
    return CustomButton(
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: _enabledButtonFinish
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = widget.userHabit.userHabitId;

              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
