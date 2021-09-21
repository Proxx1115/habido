import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_with_date.dart';
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

import 'finance_statement_widget.dart';

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

  // Progress
  List<HabitProgressListWithDate>? _habitProgressListWithDate;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

    BlocManager.userHabitBloc.add(GetHabitProgressListWithDateEvent(_userHabit.userHabitId ?? 0));

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
              appBarTitle: LocaleKeys.detail,
              appBarLeadingColor: _primaryColor,
              backgroundColor: _backgroundColor,
              loading: state is UserHabitProgressLoading,
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    /// Progress list
                    if (_habitProgressListWithDate != null && _habitProgressListWithDate!.isNotEmpty)
                      for (int i = 0; i < _habitProgressListWithDate!.length; i++)
                        FinanceStatementWidget(
                          userHabit: _userHabit,
                          date: Func.toDate(_habitProgressListWithDate![i].date ?? ''),
                          habitProgressList: _habitProgressListWithDate![i].progresses ?? [],
                          primaryColor: _primaryColor,
                          backgroundColor: _backgroundColor,
                          expansionTileExpanded: _habitProgressListWithDate![i].isExpanded ?? false,
                          enabledActionButtons: false,
                          expenseCategoryComboList: [],
                          visibleDetailButton: false,
                          onExpansionChanged: (value) {
                            setState(() {
                              _habitProgressListWithDate![i].isExpanded = value;
                            });
                          },
                        )
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
    if (state is GetHabitProgressListWithDateSuccess) {
      _habitProgressListWithDate = state.habitProgressListWithDate;
      if (_habitProgressListWithDate != null && _habitProgressListWithDate!.isNotEmpty) {
        _habitProgressListWithDate![0].isExpanded = true;
      }
    } else if (state is GetHabitProgressListWithDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }
}
