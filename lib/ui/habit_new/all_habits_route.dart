import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit_new/active_habit_list.dart';
import 'package:habido_app/ui/habit_new/completed_habit_list.dart';
import 'package:habido_app/ui/habit_new/history_habit_list.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';

class AllHabitsRoute extends StatefulWidget {
  const AllHabitsRoute({Key? key}) : super(key: key);

  @override
  State<AllHabitsRoute> createState() => _AllHabitsRouteState();
}

class _AllHabitsRouteState extends State<AllHabitsRoute> {
  // UI
  final _allHabitsKey = GlobalKey<ScaffoldState>();

  // PageView
  PageController _pageController = PageController();
  int _currentIndex = 0;

  changePage() {
    print('index ${_currentIndex}');
    _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _allHabitsKey,
      appBarTitle: LocaleKeys.allHabit,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeHelper.margin),
        child: Column(
          children: [
            SizedBox(height: 32.0),
            _tabList(),
            SizedBox(height: 20.0),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (value) {
                  _currentIndex = value;
                },
                children: [
                  /// Идэвхтэй
                  ActiveHabitList(),

                  /// Дууссан
                  CompletedHabitList(),

                  /// Түүх
                  HistoryHabitList(), // todo
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _habitList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 99,
            color: Colors.red,
          ),
          Container(
            height: 299,
            color: Colors.yellow,
          ),
          Container(
            height: 299,
            color: Colors.teal,
          ),
          Container(
            height: 299,
            color: Colors.green,
          ),
          Container(
            height: 299,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _habitList2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 299,
            color: Colors.green,
          ),
          Container(
            height: 299,
            color: Colors.teal,
          ),
          Container(
            height: 99,
            color: Colors.red,
          ),
          Container(
            height: 299,
            color: Colors.yellow,
          ),
          Container(
            height: 299,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _tabList() {
    return Row(
      children: [
        ///
        _tabItem(
            text: LocaleKeys.active,
            isSelected: _currentIndex == 0,
            onPressed: () {
              _currentIndex = 0;
            }),

        SizedBox(width: 32.0),

        _tabItem(
            text: LocaleKeys.completed,
            isSelected: _currentIndex == 1,
            onPressed: () {
              _currentIndex = 1;
            }),

        SizedBox(width: 32.0),

        _tabItem(
            text: LocaleKeys.history,
            isSelected: _currentIndex == 2,
            onPressed: () {
              _currentIndex = 2;
            })
      ],
    );
  }

  Widget _tabItem({isSelected, text, onPressed}) {
    return Opacity(
      opacity: isSelected ? 1 : 0.6,
      child: ButtonText(
        onPressed: () {
          setState(() {
            onPressed();
            changePage();
          });
        },
        text: text,
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        padding: EdgeInsets.only(bottom: 4.0),
        border: isSelected
            ? Border(
                bottom: BorderSide(width: 2.0, color: customColors.primary),
              )
            : Border(
                bottom: BorderSide(width: 2.0, color: Colors.transparent),
              ),
      ),
    );
  }
}
