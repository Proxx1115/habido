import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/skip_user_habit_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit_new/slidable_habit_item_widget.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget.dart';
import 'package:habido_app/ui/home_new/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/indicatorItem.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitDashboard extends StatefulWidget {
  const HabitDashboard({Key? key}) : super(key: key);

  @override
  State<HabitDashboard> createState() => _HabitDashboardState();
}

class _HabitDashboardState extends State<HabitDashboard> {
  bool _isUserHabitEmpty = false;

  /// For You Habit Data
  final List _habitForYouData = [
    {
      "name": "Өдөр бүр 6 аяга ус уух",
      "photo": Assets.habido_assistant,
      "color": Colors.blue,
      "date": "12 сар",
      "time": ["24:00", "24:00", "24:00"]
    },
    {
      "name": "Өдөр бүр 6 аяга ус уух",
      "photo": Assets.habido_assistant,
      "color": Colors.teal,
      "date": "12 сар",
      "time": ["24:00", "24:00", "24:00"]
    },
    {
      "name": "Өдөр бүр 6 аяга ус уух",
      "photo": Assets.habido_assistant,
      "color": Colors.brown,
      "date": "12 сар",
      "time": ["24:00", "24:00", "24:00"]
    },
    {
      "name": "Өдөр бүр 6 аяга ус уух",
      "photo": Assets.habido_assistant,
      "color": Colors.green,
      "date": "12 сар",
      "time": ["24:00", "24:00", "24:00"]
    },
    {
      "name": "Өдөр бүр 6 аяга ус уух",
      "photo": Assets.habido_assistant,
      "color": Colors.purple,
      "date": "12 сар",
      "time": ["24:00", "24:00", "24:00"]
    },
  ];

  double width = window.physicalSize.width; // todo change

  /// PageView - For You Habit
  PageController _pageController = PageController();
// viewportFraction: (window.physicalSize.width - 20.0) / window.physicalSize.width
  int _currentIndex = 0;

  /// New Habit Suggestions
  List _newhabitSuggestionLists = [
    {"asset": Assets.assistant, "name": "Явган алхах"},
    {"asset": Assets.assistant, "name": "Унтаж амрах"},
    {"asset": Assets.assistant, "name": "Ажлын өдрөө дүгнэх"},
    {"asset": Assets.assistant, "name": "Бясалгал"},
    {"asset": Assets.assistant, "name": "Хуримтлал үүсгэх"},
  ];

  // User habits
  List<UserHabit>? _todayUserHabits;

  @override
  void initState() {
    super.initState();

    BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: customColors.primaryBackground, // primaryBackground
      child: Column(
        children: [
          /// App bar
          DashboardAppBar(
            title: LocaleKeys.habit,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
          ),

          /// List
          Expanded(
            child: _listItems(),
          ),
        ],
      ),
      floatingActionButton: CustomShowcase(
        showcaseKey: ShowcaseKey.addHabit,
        description: LocaleKeys.showcaseAddHabit,
        shapeBorder: CircleBorder(),
        overlayPadding: EdgeInsets.all(10.0),
        child: BlocProvider.value(
          value: BlocManager.dashboardBloc,
          child: BlocListener<DashboardBloc, DashboardState>(
            listener: _blocListener,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                return CustomButton(
                  margin: EdgeInsets.fromLTRB(45.0, 0, 45.0, 30.0),
                  text: LocaleKeys.planNewHabit,
                  fontWeight: FontWeight.w700,
                  alignment: Alignment.bottomCenter,
                  borderRadius: BorderRadius.circular(15.0),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.habitCategories);
                  },
                );
              },
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Plan New Habit Btn
    );
  }

  Widget _listItems() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 13.0),

          /// Calendar
          Container(
            margin: EdgeInsets.symmetric(horizontal: SizeHelper.margin),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Гуравдугаар сар", // todo dynamic
                      fontSize: 13.0,
                    ),
                    ButtonText(
                      onPressed: () {
                        _navigateToAllHabitsRoute();
                      },
                      text: LocaleKeys.seeAllHabits,
                      fontSize: 10.0,
                      color: customColors.primary,
                      margin: EdgeInsets.only(right: 23.0),
                      underlined: true,
                    ),
                  ],
                ),

                ///
                SizedBox(height: 15.0),

                /// Calendar
                Container(
                  height: 43,
                  color: Colors.cyanAccent,
                  width: double.infinity,
                  child: Center(child: Text("Календар")),
                ),
              ],
            ),
          ),

          SizedBox(height: 26.0),

          /// Habits For You
          _habitsForYou(),

          SizedBox(height: 18.0),

          // New Habit
          _isUserHabitEmpty
              ? _newHabitWidget()
              :
              // Today's Habits
              _userHabitListWidget(),

          SizedBox(
            height: 120,
          )
        ],
      ),
    );
  }

  Widget _habitsForYou() {
    return Column(
      children: [
        /// Text
        CustomText(
          LocaleKeys.habitForYou,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          margin: EdgeInsets.only(left: SizeHelper.margin),
        ),
        SizedBox(height: 15.0),

        /// Habit For You
        Container(
          height: 82,
          margin: EdgeInsets.symmetric(horizontal: SizeHelper.margin),
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            children: [
              for (var el in _habitForYouData) _habitForYouItem(el),
            ],
          ),
        ),
        SizedBox(height: SizeHelper.margin),

        /// Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _habitForYouData.length; i++)
              IndicatorItem(
                index: i,
                currentIndex: _currentIndex,
              )
          ],
        ),
      ],
    );
  }

  Widget _habitForYouItem(data) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: customColors.whiteBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            /// Image
            Container(
                margin: EdgeInsets.only(right: 15.0),
                padding: EdgeInsets.all(10.0),
                height: 82.0,
                width: 82.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
                  color: data["color"],
                ),
                child: SvgPicture.asset(Assets.male_habido)
                // CachedNetworkImage(
                //   imageUrl: "https://www.pngmart.com/image/159636",
                //   fit: BoxFit.fitHeight,
                //   placeholder: (context, url) => Container(),
                //   errorWidget: (context, url, error) => Container(),
                // ),
                ),

            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 11.0),

                  /// Title
                  CustomText(
                    data["name"],
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 3.0),

                  /// Date
                  CustomText(
                    '${LocaleKeys.time} - ${data["date"]}',
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                  ),

                  SizedBox(height: 11.0),

                  /// Time
                  Row(
                    children: [
                      for (var el in data["time"])
                        TagItemWidget(
                          text: el,
                          margin: EdgeInsets.only(right: 8.0),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _newHabitWidget() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: SizeHelper.margin),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
        decoration: BoxDecoration(
          color: customColors.whiteBackground,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            CustomText(
              LocaleKeys.readyToStartNewHabit,
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              alignment: Alignment.center,
            ),
            SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              child: Wrap(
                spacing: 10.0,
                runSpacing: 15.0,
                children: [
                  for (var el in _newhabitSuggestionLists) _habitItem(asset: el["asset"], name: el["name"]),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _habitItem({required String asset, required String name}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: customColors.whiteBackground,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              asset,
              height: 25.0,
              width: 25.0,
              color: customColors.iconLightGray,
            ),
            SizedBox(width: 10.0),
            CustomText(
              name,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: customColors.grayText,
            )
          ],
        ),
      ),
    );
  }

  Widget _userHabitListWidget() {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.marginBottom),
        child: BlocProvider.value(
          value: BlocManager.dashboardBloc,
          child: BlocListener<DashboardBloc, DashboardState>(
            listener: _blocListener,
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                String todayDone = '';
                List<UserHabit>? todayUserHabits = _todayUserHabits;
                if (todayUserHabits != null) {
                  todayDone =
                      todayUserHabits.where((element) => element.isDone!).toList().length.toString() + '/' + _todayUserHabits!.length.toString();
                }
                return Column(
                  children: [
                    /// Today
                    CustomText(
                      LocaleKeys.todaysHabit,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),

                    SizedBox(height: 12.0),

                    if (_todayUserHabits != null && _todayUserHabits!.isNotEmpty)
                      _habitList(LocaleKeys.today, _todayUserHabits!, true, true, todayDone),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DashboardState state) {
    if (state is RefreshDashboardUserHabitsSuccess) {
      _todayUserHabits = state.todayUserHabits;
      if ((_todayUserHabits == null) || (_todayUserHabits?.length == 0))
        _isUserHabitEmpty = true;
      else
        _isUserHabitEmpty = false;
    } else if (state is SkipUserHabitSuccess) {
      print('SkipUserHabitSuccess');
    } else if (state is SkipUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _getReminderTimes(reminders) {
    List<String> _reminderTimes = [];
    for (var el in reminders) {
      _reminderTimes.add("${Func.toInt(el.time) ~/ 60}:${Func.toInt(el.time) % 60}");
    }
    return _reminderTimes;
  }

  Widget _habitList(String title, List<UserHabit> userHabitList, bool enabled, bool isToday, String? todayText) {
    return Column(
      children: List.generate(
        userHabitList.length,
        (index) => SlidableHabitItemWidget(
          isStart: index == 0,
          isEnd: index == userHabitList.length - 1,
          delay: index * 0.2,
          text: userHabitList[index].name ?? '',
          subText: "Өдөр бүр", //userHabitList[index].name ?? '' // todo sda
          reminders: _getReminderTimes(userHabitList[index].userHabitReminders!),
          leadingUrl: userHabitList[index].habit?.photo,
          leadingBackgroundColor: (userHabitList[index].habit?.color != null) ? HexColor.fromHex(userHabitList[index].habit!.color!) : null,
          processPercent: 50, // todo sda
          //_getSuffixAsset(userHabitList[index])
          // suffixAsset: (userHabitList[index].isDone ?? false) ? Assets.check2 : Assets.arrow_forward,
          // suffixColor: (userHabitList[index].isDone ?? false) ? customColors.iconSeaGreen : customColors.primary,
          onPressed: () {
            // Is finished
            if (userHabitList[index].isDone ?? false) return;

            // Navigate
            if (enabled && userHabitList[index].habit?.goalSettings != null) {
              String? route = HabitHelper.getProgressRoute(userHabitList[index].habit!);
              if (route != null) {
                Navigator.pushNamed(
                  context,
                  route,
                  arguments: {
                    'userHabit': userHabitList[index],
                  },
                );
              }
            }
          },
          onPressedSkip: (userHabitList[index].isDone ?? false)
              ? null
              : () {
                  showCustomDialog(
                    context,
                    isDismissible: true,
                    child: CustomDialogBody(
                      text: LocaleKeys.sureToSkipHabit,
                      // height: 300.0,
                      buttonText: LocaleKeys.skip,
                      button2Text: LocaleKeys.no,
                      onPressedButton: () {
                        var skipUserHabitRequest = SkipUserHabitRequest()
                          ..userHabitId = userHabitList[index].userHabitId
                          ..skipDay = Func.toDateStr(DateTime.now());
                        BlocManager.dashboardBloc.add(SkipUserHabitEvent(skipUserHabitRequest));
                      },
                    ),
                  );
                },
          onPressedEdit: (userHabitList[index].isDone ?? false)
              ? null
              : () {
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

  _navigateToAllHabitsRoute() {
    Navigator.pushNamed(context, Routes.allHabits);
  }
}
