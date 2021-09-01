import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/text.dart';

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
            return ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _isExpandedTodayUserHabits = !isExpanded;
                  // _todayUserHabits![index].isExpanded = !isExpanded;
                });
              },
              children: [
                /// Today
                if (_todayUserHabits != null && _todayUserHabits!.isNotEmpty)
                  _expansionPanel(
                    LocaleKeys.today,
                    _todayUserHabits!,
                  ),

                /// Tomorrow
                // if (_tomorrowUserHabits != null && _tomorrowUserHabits!.isNotEmpty)
                //   _dropDownContainer(LocaleKeys.tomorrow, _tomorrowUserHabits!),
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
    return ExpansionPanelList(
      children: [
        _expansionPanel('Test', userHabitList)
        // ExpansionPanel(headerBuilder: headerBuilder, body: body),
      ],
    );

    // return ExpansionPanel(
    //   headerBuilder: (BuildContext context, bool isExpanded) {
    //     return ListTile(
    //       title: CustomText(category.categoryName),
    //     );
    //   },
    //   body: Column(
    //     children: [
    //       if (category.psyTestResults != null)
    //         for (var el in category.psyTestResults!)
    //           ListTile(
    //             title: CustomText(el.testResult?.text),
    //             subtitle: CustomText(el.testResult?.pointRange),
    //             // trailing: const Icon(Icons.delete),
    //             onTap: () {
    //               // setState(() {
    //               //   _data.removeWhere((Item currentItem) => item == currentItem);
    //               // });
    //             },
    //           ),
    //     ],
    //   ),
    //   isExpanded: category.isExpanded ?? false,
    // );

    // return Container(
    //   child: Column(
    //     children: [
    //       /// Title
    //       CustomText(title),
    //
    //       /// List
    //       for (var el in userHabitList) _userHabitListItem(el),
    //     ],
    //   ),
    // );
  }

  ExpansionPanel _expansionPanel(String title, List<UserHabit> userHabitList) {
    // return ExpansionPanel(
    //   headerBuilder: (BuildContext context, bool isExpanded) {
    //     return ListTile(
    //       title: CustomText(category.categoryName),
    //     );
    //   },
    //   body: Column(
    //     children: [
    //       if (category.psyTestResults != null)
    //         for (var el in category.psyTestResults!)
    //           ListTile(
    //             title: CustomText(el.testResult?.text),
    //             subtitle: CustomText(el.testResult?.pointRange),
    //             // trailing: const Icon(Icons.delete),
    //             onTap: () {
    //               // setState(() {
    //               //   _data.removeWhere((Item currentItem) => item == currentItem);
    //               // });
    //             },
    //           ),
    //     ],
    //   ),
    //   isExpanded: category.isExpanded ?? false,
    // );

    return ExpansionPanel(
      isExpanded: _isExpandedTodayUserHabits,
      backgroundColor: customColors.primaryBackground,

      headerBuilder: (BuildContext context, bool isExpanded) {
        return CustomText(title);
        // return ListTile(
        //   title: CustomText(category.categoryName),
        // );
      },
      body: Column(
        children: [
          if (userHabitList.isNotEmpty)
            for (var el in userHabitList)
              _userHabitListItem(el),
                    // ListTile(
                    //   title: CustomText(el.name),
                    //   // subtitle: CustomText(el.testResult?.pointRange),
                    //   // trailing: const Icon(Icons.delete),
                    //   onTap: () {
                    //     // setState(() {
                    //     //   _data.removeWhere((Item currentItem) => item == currentItem);
                    //     // });
                    //   },
                    // ),

              // _userHabitListItem(el),
        ],
      ),
    );
  }

  Widget _userHabitListItem(UserHabit userHabit) {
    return ListItemContainer(
      height: 70.0,
      margin: EdgeInsets.only(bottom: 15.0),
      text: userHabit.name ?? '',
      leadingImageUrl: userHabit.habit?.photo,
      leadingBackgroundColor: (userHabit.habit?.color != null) ? HexColor.fromHex(userHabit.habit!.color!) : null,
      onPressed: () {
        //
      },
    );
  }
}
