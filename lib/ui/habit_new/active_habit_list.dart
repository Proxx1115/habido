import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/all_habit_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit_new/habit_item_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/widgets/dialogs.dart';

class ActiveHabitList extends StatefulWidget {
  const ActiveHabitList({Key? key}) : super(key: key);

  @override
  State<ActiveHabitList> createState() => _ActiveHabitListState();
}

class _ActiveHabitListState extends State<ActiveHabitList> {
  List<ActiveHabit> _activeHabitList = [];

  @override
  void initState() {
    super.initState();
    BlocManager.allHabitBloc.add(GetActiveHabitFirstEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.allHabitBloc,
      child: BlocListener<AllHabitBloc, AllHabitState>(
        listener: _blocListener,
        child: BlocBuilder<AllHabitBloc, AllHabitState>(builder: (context, state) {
          return ListView.builder(
            itemBuilder: (context, index) => HabitItemWidget(
              data: _activeHabitList[index],
              isActiveHabit: true,
              onTap: () {
                _navigateToHabitDetailRoute(context, _activeHabitList[index]);
              },
            ),
            itemCount: _activeHabitList.length,
          );
        }),
      ),
    );
  }

  void _blocListener(BuildContext context, AllHabitState state) {
    if (state is GetActiveHabitFirstSuccess) {
      _activeHabitList = state.activeHabitList;
      print('asdsadas ${state.activeHabitList}');
    } else if (state is GetActiveHabitFirstFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _navigateToHabitDetailRoute(BuildContext context, ActiveHabit habitData) {
    // Navigate
    // if (habitData.goalType != null) {
    String? route = HabitHelper.getDetailRoute(habitData.goalType!);
    if (route != null) {
      Navigator.pushNamed(
        context,
        route,
        arguments: {
          'userHabitId': habitData.userHabitId,
          'name': habitData.name,
        },
      );
    }
  }
}
