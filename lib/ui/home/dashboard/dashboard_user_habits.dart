import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/dialogs.dart';

class DashboardUserHabits extends StatefulWidget {
  const DashboardUserHabits({Key? key}) : super(key: key);

  @override
  _DashboardUserHabitsState createState() => _DashboardUserHabitsState();
}

class _DashboardUserHabitsState extends State<DashboardUserHabits> {
  List<UserHabit>? _todayUserHabits;
  bool _isExpandedTodayUserHabits = false;
  List<UserHabit>? _tomorrowUserHabits;

  @override
  void initState() {
    BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.dashboardBloc,
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: _blocListener,
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Column(
              children: [
                /// Today
                if (_todayUserHabits != null && _todayUserHabits!.isNotEmpty)
                  _expandableHabitList(
                    LocaleKeys.today,
                    _todayUserHabits!,
                  ),

                /// Tomorrow
                if (_tomorrowUserHabits != null && _tomorrowUserHabits!.isNotEmpty)
                  _expandableHabitList(
                    LocaleKeys.tomorrow,
                    _tomorrowUserHabits!,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DashboardState state) {
    if (state is RefreshDashboardUserHabitsSuccess) {
      _todayUserHabits = state.todayUserHabits;
      _tomorrowUserHabits = state.tomorrowUserHabits;
    }
  }

  Widget _expandableHabitList(String title, List<UserHabit> userHabitList) {
    return ExpandableContainer(
      title: title,
      expandableListItems: List.generate(
        userHabitList.length,
        (index) => ExpandableListItem(
          text: userHabitList[index].name ?? '',
          leadingImageUrl: userHabitList[index].habit?.photo,
          leadingBackgroundColor:
              (userHabitList[index].habit?.color != null) ? HexColor.fromHex(userHabitList[index].habit!.color!) : null,
          onPressed: () {
            // var route = HabitHelper.getProgressRoute(habitGoalSettings); // todo test
            Navigator.pushNamed(
              context,
              Routes.habitTimer,
              arguments: {
                'userHabit': userHabitList[index],
              },
            );
          },
          onPressedSkip: () {
            showCustomDialog(
              context,
              isDismissible: true,
              child: CustomDialogBody(
                text: LocaleKeys.sureToSkipHabit,
                buttonText: LocaleKeys.skip,
                button2Text: LocaleKeys.no,
                onPressedButton: () {
                  //
                },
              ),
            );
          },
          onPressedEdit: () {
            Navigator.pushNamed(
              context,
              Routes.userHabit,
              arguments: {
                'screenMode': (userHabitList[index].isDynamicHabit ?? false) ? ScreenMode.CustomEdit : ScreenMode.Edit,
                'habit': userHabitList[index].habit,
                'userHabit': userHabitList[index],
                'title': LocaleKeys.ediHabit,
              },
            );
          },
        ),
      ),
    );
  }
}
