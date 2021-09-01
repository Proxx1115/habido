import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/text.dart';

class DashboardUserHabits extends StatefulWidget {
  const DashboardUserHabits({Key? key}) : super(key: key);

  @override
  _DashboardUserHabitsState createState() => _DashboardUserHabitsState();
}

class _DashboardUserHabitsState extends State<DashboardUserHabits> {
  List<UserHabit>? _todayUserHabits;
  List<UserHabit>? _tomorrowUserHabits;

  @override
  void initState() {
    BlocManager.userHabitBloc.add(RefreshDashboardUserHabits());

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
            return Column(
              children: [
                /// Today
                if (_todayUserHabits != null && _todayUserHabits!.isNotEmpty) _dropDownContainer(LocaleKeys.today, _todayUserHabits!),

                /// Tomorrow
                if (_tomorrowUserHabits != null && _tomorrowUserHabits!.isNotEmpty)
                  _dropDownContainer(LocaleKeys.tomorrow, _tomorrowUserHabits!),
              ],
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is RefreshDashboardUserHabitsSuccess) {
      _todayUserHabits = state.todayUserHabits;
      _tomorrowUserHabits = state.tomorrowUserHabits;
    }
  }

  Widget _dropDownContainer(String title, List<UserHabit> userHabitList) {
    return Container(
      child: Column(
        children: [
          /// Title
          CustomText(title),

          /// List
          for (var el in userHabitList) _userHabitListItem(el),
        ],
      ),
    );
  }

  Widget _userHabitListItem(UserHabit userHabit) {
    return Container(
      child: CustomText(userHabit.name),
    );
  }
}
