import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/models/user_habit_plan_count.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HabitDetailWithCountRoute extends StatefulWidget {
  final ActiveHabit? habitData;
  const HabitDetailWithCountRoute({Key? key, this.habitData}) : super(key: key);

  @override
  State<HabitDetailWithCountRoute> createState() => _HabitDetailWithCountRouteState();
}

class _HabitDetailWithCountRouteState extends State<HabitDetailWithCountRoute> {
  UserHabitPlanCount? _userHabitPlanCount;

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetUserHabitPlanCountEvent(1321));
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
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
    return CustomScaffold(
      appBarTitle: "Дагаа", //widget.habitData!.name
      child: Container(
        padding: SizeHelper.screenPadding,
        child: _userHabitPlanCount != null
            ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                /// Result
                //     RoundedCornerListView(
                //       // padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
                //       children: [
                //         /// RESULT_INFO

                //   ],
                // ),
                Text('completedPlans ${_userHabitPlanCount!.completedPlans}'),
                Text('skipPlans ${_userHabitPlanCount!.skipPlans}'),
                Text('totalPlans ${_userHabitPlanCount!.totalPlans}'),
                Text('uncompletedPlans ${_userHabitPlanCount!.uncompletedPlans}'),
              ])
            : Container(),
      ),
    );
  }
}
