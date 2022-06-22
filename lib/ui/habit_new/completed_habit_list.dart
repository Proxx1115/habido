import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/all_habit_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/completed_habit.dart';
import 'package:habido_app/ui/habit_new/habit_item_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';

class CompletedHabitList extends StatefulWidget {
  const CompletedHabitList({Key? key}) : super(key: key);

  @override
  State<CompletedHabitList> createState() => _CompletedHabitListState();
}

class _CompletedHabitListState extends State<CompletedHabitList> {
  List<CompletedHabit> _completedHabitList = [];

  @override
  void initState() {
    super.initState();
    BlocManager.allHabitBloc.add(GetCompletedHabitFirstEvent());
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
              data: _completedHabitList[index],
              isActiveHabit: false,
              onTap: _navigateToHabitDetailRoute,
            ),
            itemCount: _completedHabitList.length,
          );
        }),
      ),
    );
  }

  void _blocListener(BuildContext context, AllHabitState state) {
    if (state is GetCompletedHabitFirstSuccess) {
      _completedHabitList = state.completedHabitList;
      print('asdsadas ${state.completedHabitList}');
    } else if (state is GetActiveHabitFirstFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _navigateToHabitDetailRoute() {
    /// todo
  }
}
