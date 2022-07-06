import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/habit_template.dart';
import 'package:habido_app/models/skip_user_habit_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/ui/calendar_new/calendar_screen.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit_new/slidable_habit_item_widget.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget_v2.dart';
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
  final _habitDashboardKey = GlobalKey<ScaffoldState>();

  bool _isUserHabitEmpty = true;
  bool _isHabitTemplateEmpty = true;
  bool _isToday = true;

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

  // Habit templates
  List<HabitTemplate>? _habitTemplates;

  DateTime _userHabitDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    BlocManager.dashboardBloc.add(GetUserHabitByDateEvent(_userHabitDate.toString()));
    BlocManager.dashboardBloc.add(GetHabitTemplateListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _habitDashboardKey,
      backgroundColor: customColors.primaryBackground, // primaryBackground
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// App bar
          _homeAppBar(),

          /// List
          /// Rest of items
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _listItems();
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      floatingActionButton: BlocProvider.value(
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

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Plan New Habit Btn
    );
  }

  _homeAppBar() {
    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      // backgroundColor: customColors.primaryBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: DashboardAppBar(
        title: LocaleKeys.habit,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
      ),
    );
  }

  Widget _listItems() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 8.0),

          /// Calendar
          CalendarScreen(
            onDateTimeChanged: (value) {
              _userHabitDate = value;
              BlocManager.dashboardBloc.add(GetUserHabitByDateEvent(_userHabitDate.toString()));
              Func.dateTimeToDateStr(_userHabitDate) != Func.dateTimeToDateStr(DateTime.now()) ? _isToday = false : _isToday = true;
              print("isToday: ${_isToday}");
            },
          ),

          /// Habits For You
          _isHabitTemplateEmpty ? Container() : _habitsForYou(),

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
              for (var el in _habitTemplates!) _habitForYouItem(el),
            ],
          ),
        ),
        SizedBox(height: SizeHelper.margin),

        /// Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _habitTemplates!.length; i++)
              IndicatorItem(
                index: i,
                currentIndex: _currentIndex,
              )
          ],
        ),
      ],
    );
  }

  Widget _habitForYouItem(HabitTemplate template) {
    print("demplate ${template.planTerm}");
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.userHabit, arguments: {
          'screenMode': ScreenMode.HabitTemplate,
          'habitId': template.habitId,
          'habitTemplate': template,
          'title': LocaleKeys.createHabit,
        });
      },
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
                color: HexColor.fromHex(template.color!),
              ),
              child:
                  // SvgPicture.asset(Assets.male_habido)
                  CachedNetworkImage(
                imageUrl: template.icon!,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 11.0),

                  /// Title
                  CustomText(
                    template.name!,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 3.0),

                  /// Date
                  CustomText(
                    '${LocaleKeys.time} - ${template.duration!} ${LocaleKeys.day}',
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                  ),

                  SizedBox(height: 11.0),

                  /// Time
                  Row(
                    children: [
                      for (UserHabitReminders el in template.templateReminders ?? [])
                        _reminderItem(new TimeOfDay(
                          hour: Func.toInt(el.time) ~/ 60,
                          minute: Func.toInt(el.time) % 60,
                        ))
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

  Widget _reminderItem(TimeOfDay timeOfDay) {
    String hour = timeOfDay.hour < 10 ? '0${timeOfDay.hour}' : '${timeOfDay.hour}';
    String minute = timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : '${timeOfDay.minute}';

    // _onPressedDeleteItem(timeOfDay);
    return TagItemWidgetV2(
      fontSize: 8.0,
      margin: EdgeInsets.only(right: 8.0),
      width: 42.0,
      height: 16.0,
      color: customColors.primaryButtonDisabledContent,
      text: '$hour:$minute',
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
                    // todo isToday ? showText : none Tushig
                    CustomText(
                      LocaleKeys.todaysHabit,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),

                    SizedBox(height: 12.0),

                    if (Func.isNotEmpty(_todayUserHabits)) _habitList(LocaleKeys.today, _todayUserHabits!, true, _isToday, todayDone),
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
    } else if (state is GetUserHabitByDateSuccess) {
      _todayUserHabits = state.userHabits;
      if ((_todayUserHabits == null) || (_todayUserHabits?.length == 0))
        _isUserHabitEmpty = true;
      else
        _isUserHabitEmpty = false;
    } else if (state is GetUserHabitByDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetHabitTemplateListSuccess) {
      if ((state.habitTemplates == null) || (state.habitTemplates?.length == 0))
        _isHabitTemplateEmpty = true;
      else {
        _isHabitTemplateEmpty = false;
        _habitTemplates = state.habitTemplates;
      }
      print("irsen uu ${_habitTemplates!.length} and ${_isHabitTemplateEmpty}");
    } else if (state is GetHabitTemplateListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _habitList(String title, List<UserHabit> userHabitList, bool enabled, bool isToday, String? todayText) {
    return Column(
      children: List.generate(
        userHabitList.length,
        (index) => SlidableHabitItemWidget(
          status: userHabitList[index].habitState!,
          isStart: index == 0,
          isEnd: index == userHabitList.length - 1,
          delay: index * 0.2,
          text: userHabitList[index].name ?? '',
          subText: "Өдөр бүр", //userHabitList[index].name ?? '' // todo sda
          reminders: userHabitList[index]
              .userHabitReminders!
              .take(3)
              .toList()
              .map((e) => ("${(Func.toInt(e.time) ~/ 60)}".padLeft(2, "0") + ":" + "${Func.toInt(e.time) % 60}".padLeft(2, "0")))
              .toList(),
          leadingUrl: userHabitList[index].habit?.photo,
          leadingBackgroundColor: (userHabitList[index].habit?.color != null) ? HexColor.fromHex(userHabitList[index].habit!.color!) : null,
          processPercent: userHabitList[index].percentage!.toInt(),
          // processPercent: 50,
          //_getSuffixAsset(userHabitList[index])
          // suffixAsset: (userHabitList[index].isDone ?? false) ? Assets.check2 : Assets.arrow_forward,
          // suffixColor: (userHabitList[index].isDone ?? false) ? customColors.iconSeaGreen : customColors.primary,
          onPressed: () {
            // Is finished
            if (userHabitList[index].isDone ?? false) return;

            // Navigate
            if (enabled && userHabitList[index].habit?.goalSettings != null && isToday) {
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
          onPressedSkip: ((!userHabitList[index].isDone!) && _isToday)
              ? () {
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
                }
              : null,
          onPressedEdit: ((!userHabitList[index].isDone!) && _isToday)
              ? () {
                  Navigator.pushNamed(
                    context,
                    Routes.userHabit,
                    arguments: {
                      'screenMode': (userHabitList[index].isDynamicHabit ?? false) ? ScreenMode.CustomEdit : ScreenMode.Edit,
                      'habitId': userHabitList[index].habitId,
                      'userHabit': userHabitList[index],
                      'title': LocaleKeys.ediHabit,
                    },
                  );
                }
              : null,
          onPressedDetail: () {
            _navigateToHabitDetailRoute(context, userHabitList[index]);
          },
        ),
      ),
    );
  }

  _navigateToHabitDetailRoute(BuildContext context, UserHabit habitData) {
    // Navigate
    // if (habitData.goalType != null) {
    String? route = HabitHelper.getDetailRoute(habitData.habit!.goalSettings!.toolType!);
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
