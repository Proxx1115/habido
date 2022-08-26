import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_plan_count.dart';
import 'package:habido_app/ui/habit_new/habit_detail/delete_button_widget.dart';
import 'package:habido_app/ui/habit_new/habit_detail/no_habit_graph_widget.dart';
import 'package:habido_app/ui/habit_new/habit_detail/performance_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitDetailWithCountRoute extends StatefulWidget {
  final UserHabit? userHabit;
  final bool? isActive;
  final Function? refreshHabits;

  const HabitDetailWithCountRoute({
    Key? key,
    this.userHabit,
    this.isActive = false,
    this.refreshHabits,
  }) : super(key: key);

  @override
  State<HabitDetailWithCountRoute> createState() => _HabitDetailWithCountRouteState();
}

class _HabitDetailWithCountRouteState extends State<HabitDetailWithCountRoute> {
  UserHabitPlanCount? _userHabitPlanCount;

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetUserHabitPlanCountEvent(widget.userHabit!.userHabitId!));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.userHabitBloc,
        child: BlocListener<UserHabitBloc, UserHabitState>(
          listener: _blocListener,
          child: BlocBuilder<UserHabitBloc, UserHabitState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  _blocListener(BuildContext context, UserHabitState state) {
    if (state is GetUserHabitPlanCountSuccess) {
      _userHabitPlanCount = state.userHabitPlanCount;
    } else if (state is GetUserHabitPlanCountFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is DeleteUserHabitSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
            widget.refreshHabits!();
          },
        ),
      );
    } else if (state is DeleteUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
        ),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
    return CustomScaffold(
      appBarTitle: widget.userHabit!.name,
      child: SingleChildScrollView(
        padding: SizeHelper.screenPadding,
        child: _userHabitPlanCount != null
            ? Column(
                children: [
                  SizedBox(height: 18.0),
                  CustomText(
                    LocaleKeys.execution,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
                  SizedBox(height: 15.0),
                  PerformanceWidget(
                    totalPlans: _userHabitPlanCount!.totalPlans,
                    completedPlans: _userHabitPlanCount!.completedPlans,
                    skipPlans: _userHabitPlanCount!.skipPlans,
                    uncompletedPlans: _userHabitPlanCount!.uncompletedPlans,
                  ),

                  /// Chart
                  SizedBox(
                    height: 15,
                  ),
                  NoHabitGraph(),

                  /// Delete Btn
                  if (widget.isActive ?? false)
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        Align(
                          alignment: Alignment.topRight,
                          child: DeleteButtonWidget(
                            onDelete: () {
                              BlocManager.userHabitBloc.add(DeleteUserHabitEvent(widget.userHabit!.userHabitId!));
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : Container(),
      ),
    );
  }
}
