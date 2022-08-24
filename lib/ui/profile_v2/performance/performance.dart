import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/mood_tracker_monthly_stat_response.dart';
import 'package:habido_app/models/mood_tracker_latest.dart';
import 'package:habido_app/models/mood_tracker_latest_response.dart';
import 'package:habido_app/models/mood_tracker_reason_with_count.dart';
import 'package:habido_app/models/mood_tracker_monthly_reason_response.dart';
import 'package:habido_app/models/profile_habit_count.dart';
import 'package:habido_app/ui/profile_v2/performance/feeling_item.dart';
import 'package:habido_app/ui/profile_v2/performance/performance_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/user_habit_process.dart';

class Performance extends StatefulWidget {
  const Performance({
    Key? key,
  }) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  var currentDateTime = DateTime.now();

  List _colorsOpacity = [
    Color(0xff73BBB6).withOpacity(0),
    Color(0xff73BBB6).withOpacity(0.2),
    Color(0xff73BBB6).withOpacity(0.4),
    Color(0xff73BBB6).withOpacity(0.6),
    Color(0xff73BBB6).withOpacity(0.8),
    Color(0xff73BBB6),
  ];

  Map _calendar1 = {"color": Color(0xff73BBB6), "text": LocaleKeys.emoji1};
  Map _calendar2 = {
    "color": Color(0xff73BBB6).withOpacity(0.8),
    "text": LocaleKeys.emoji2
  };
  Map _calendar3 = {
    "color": Color(0xff73BBB6).withOpacity(0.6),
    "text": LocaleKeys.emoji3
  };
  Map _calendar4 = {
    "color": Color(0xff73BBB6).withOpacity(0.4),
    "text": LocaleKeys.emoji4
  };
  Map _calendar5 = {
    "color": Color(0xff73BBB6).withOpacity(0.2),
    "text": LocaleKeys.notNoted
  };
  List _calendarDesc = [];

  /// MOOD TRACKER RESPONSE
  MoodTrackerMonthlyReasonResponse? _specificMoodTrackerReasonResponse;
  late MoodTrackerReasonWithCount _moodReason;

  bool positive = true;

  /// MOOD TRACKER LATEST
  List<MoodTrackerLatest> _moodTracker = [];

  /// MOOD TRACKER MONTHLY STAT
  MoodTrackerMonthlyStatResponse? calendarMonthDaysResponse;

  var romboNumber = ["I", "II", "III", "IV", "V"];

  List testArray = [0, 1, 2, 3];

  /// PROFILE HABIT COUNT
  ProfileHabitCount? profileHabitCount;

  @override
  void initState() {
    currentDateTime = DateTime(currentDateTime.year, currentDateTime.month);
    _calendarDesc = [
      _calendar1,
      _calendar2,
      _calendar3,
      _calendar4,
      _calendar5
    ];
    BlocManager.performanceBloc
        .add(GetMonthlyReasonEvent(DateTime.now().year, DateTime.now().month));
    BlocManager.performanceBloc.add(GetMoodTrackerLatestEvent());
    BlocManager.performanceBloc.add(GetProfileHabitCountEvent());
    getMonthlyReason();
    super.initState();
  }

  getMonthlyReason() {
    BlocManager.performanceBloc
        .add(GetMonthlyStatEvent(currentDateTime.year, currentDateTime.month));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.performanceBloc,
        child: BlocListener<PerformanceBloc, PerformanceState>(
          listener: _blocListener,
          child: BlocBuilder<PerformanceBloc, PerformanceState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  String _weekDay(int week) {
    if (week == 0) {
      return 'Да';
    } else if (week == 1) {
      return 'Мя';
    } else if (week == 2) {
      return 'Лх';
    } else if (week == 3) {
      return 'Пү';
    } else if (week == 4) {
      return 'Ба';
    } else if (week == 5) {
      return 'Бя';
    } else {
      return 'Ня';
    }
  }

  void _blocListener(BuildContext context, PerformanceState state) {
    if (state is MoodMonthlyReasonSuccess) {
      _specificMoodTrackerReasonResponse =
          state.specificMoodTrackerReasonResponse;
      // _moodReason = _specificMoodTrackerReasonResponse!.positiveReasons!;
      _moodReason = _specificMoodTrackerReasonResponse!.positiveReasons!;
    } else if (state is ModdMonthlyReasonFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is MoodTrackerLatestSuccess) {
      _moodTracker = state.moodTracker;
    } else if (state is ModdTrackerLatestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is MoodMonthlyStatSuccess) {
      calendarMonthDaysResponse = state.calendarMonthDaysResponse;
    } else if (state is ModdMonthlyStatFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is ProfileHabitCountSuccess) {
      // calendarMonthDaysResponse = state.calendarMonthDaysResponse;
      profileHabitCount = state.profileHabitCount;
    } else if (state is ProfileHabitCountFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, PerformanceState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                LocaleKeys.myProcess,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              NoSplashContainer(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.allHabits);
                  },
                  child: Container(
                    child: CustomText(
                      LocaleKeys.seeAllHabits,
                      fontSize: 13,
                      color: customColors.primary,
                      underlined: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          profileHabitCount != null ? _myProcess() : Container(),
          // profileHabitCount != null
          //     ? UserHabitProcessWidget(
          //         processDataList: testArray,
          //       )
          //     : Container(),
          SizedBox(height: 15),
          CustomText(
            LocaleKeys.myFeeling,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          SizedBox(height: 15),
          calendarMonthDaysResponse != null ? _calender() : Container(),
          _myFeeling(),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.sensitivityNotes);
            },
            child: Container(
              padding: EdgeInsets.only(right: 12.0),
              alignment: Alignment.bottomRight,
              child: Text(
                LocaleKeys.seeHistory,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: customColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // ElevatedButton(
          //     onPressed: () {
          //       print("tracker:${_moodTracker[0].answerImageUrl!}");
          //     },
          //     child: CustomText('okey')),

          _moodTracker.length > 0
              ? NoSplashContainer(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.sensitivityNotes);
                    },
                    child: Column(
                      children: [
                        for (int i = 0;
                            i <
                                (_moodTracker.length >= 3
                                    ? 3
                                    : _moodTracker.length);
                            i++)
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: FeelingItem(
                              state: false,
                              answerImageUrl:
                                  '${_moodTracker[i].answerImageUrl!}',
                              answerText: '${_moodTracker[i].answerText!}',
                              reasons: _moodTracker[i].reasons!,
                              writtenAnswer:
                                  _moodTracker[i].writtenAnswer ?? "",
                              date: '${_moodTracker[i].date!}',
                              maxLines: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _myFeeling() {
    return _specificMoodTrackerReasonResponse != null
        ? Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: customColors.primaryButtonDisabledContent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  positive = true;
                                  _moodReason =
                                      _specificMoodTrackerReasonResponse!
                                          .positiveReasons!;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: positive
                                        ? customColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: CustomText(
                                    LocaleKeys.positive,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              )),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    positive = false;
                                    _moodReason =
                                        _specificMoodTrackerReasonResponse!
                                            .negativeReasons!;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: positive
                                          ? Colors.transparent
                                          : customColors.primary,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CustomText(
                                      LocaleKeys.negative,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomText(
                          "${positive ? _specificMoodTrackerReasonResponse!.positiveReasons!.specificMoodTotalCount! : _specificMoodTrackerReasonResponse!.negativeReasons!.specificMoodTotalCount}/${_specificMoodTrackerReasonResponse!.totalMoodCount}",
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          alignment: Alignment.center,
                        ),
                        CustomText(
                          LocaleKeys.totalRecorded,
                          color: customColors.primary,
                          fontWeight: FontWeight.w500,
                          alignment: Alignment.center,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var el in _moodReason.specificReasons!)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    el.reasonName,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  CustomText(
                                    "${el.count}",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              SizedBox(height: 7)
                            ],
                          )
                      ],
                    ),
                  ),
                )
              ],
            ))
        : Container();
  }

  Widget _calender() {
    return Container(
      height: ResponsiveFlutter.of(context).hp(20),
      width: ResponsiveFlutter.of(context).wp(100),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveFlutter.of(context).hp(2.5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 15,
              ),
              CustomText(
                "${calendarMonthDaysResponse!.month} сар",
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
                  onTap: () {
                    showCustomDialog(
                      context,
                      child: CustomDialogBody(
                        // buttonText: "Цонхыг хаах",
                        primaryColor: customColors.greyBackground,
                        child: Column(
                          children: [
                            /// Image
                            // if (Func.isNotEmpty(_notifList[index].photo))
                            if (true) //todo yela

                              /// Body
                              CustomText(
                                LocaleKeys.moodCalendarInfo,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                maxLines: 100,
                                // margin: EdgeInsets.only(bottom: 20.0),
                              ),

                            SizedBox(height: 20),
                            // Column(
                            //   children: [],
                            // )
                            for (var i = 0; i < _calendarDesc.length; i++)
                              _dayItemBottomSheet(
                                  color: _calendarDesc[i]['color'],
                                  text: _calendarDesc[i]['text']),
                            const SizedBox(height: 40),

                            CustomButton(
                              text: "Хаах",
                              contentColor: customColors.primaryText,
                              backgroundColor: customColors.greyBackground,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                        onPressedButton: () {},
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    Assets.warning_calendar,
                    width: ResponsiveFlutter.of(context).wp(2.5),
                    height: ResponsiveFlutter.of(context).hp(2.5),
                  )),
            ],
          )),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(),
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: 7,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Center(child: Text(_weekDay(index))));
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                          ),
                        ),
                        flex: 11,
                      ),
                      Expanded(
                        child: Container(),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (currentDateTime.month != 1) {
                              currentDateTime = DateTime(
                                currentDateTime.year,
                                currentDateTime.month - 1,
                              );
                            } else {
                              currentDateTime = DateTime(
                                currentDateTime.year - 1,
                                currentDateTime.month - 1,
                              );
                            }

                            getMonthlyReason();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveFlutter.of(context).hp(2),
                            ),
                            child: SvgPicture.asset(
                              Assets.arrow_back,
                              color: customColors.secondaryButtonContent,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(children: [
                          Expanded(
                            flex: 30,
                            child: Column(
                              children: [
                                for (var orderWeek in romboNumber)
                                  Container(
                                      margin: EdgeInsets.only(
                                        bottom: ResponsiveFlutter.of(context)
                                            .fontSize(0.2),
                                        right: ResponsiveFlutter.of(context)
                                            .fontSize(0.2),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          orderWeek,
                                          lineSpace:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(0.13),
                                          fontSize: 11,
                                          alignment: Alignment.center,
                                          // bgColor: Colors.amber,
                                        ),
                                      )),
                              ],
                            ),
                          ),
                          Expanded(child: SizedBox()),
                        ]),
                        flex: 2,
                      ),
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: calendarMonthDaysResponse!.days!.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(
                                  ResponsiveFlutter.of(context).fontSize(0.1)),
                              color: _colorsOpacity[Func.toInt(
                                  calendarMonthDaysResponse!
                                      .days![index].point!)],
                              // width: ResponsiveFlutter.of(context).wp(2),
                              // height: ResponsiveFlutter.of(context).hp(0.6),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                ResponsiveFlutter.of(context).fontSize(0.3),
                            crossAxisCount: 7,
                          ),
                        ),
                        flex: 11,
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (DateTime.now().month != currentDateTime.month ||
                                DateTime.now().year != currentDateTime.year) {
                              if (currentDateTime.month != 12) {
                                currentDateTime = DateTime(
                                  currentDateTime.year,
                                  currentDateTime.month + 1,
                                );
                                print(
                                    "arrawNext:${currentDateTime.year} ${currentDateTime.month}");
                              } else {
                                currentDateTime = DateTime(
                                  currentDateTime.year + 1,
                                  currentDateTime.month + 1,
                                );
                                print(
                                    "arrawNext2:${currentDateTime.year} ${currentDateTime.month}");
                              }

                              getMonthlyReason();
                            } else {}
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveFlutter.of(context).hp(2),
                            ),
                            child: SvgPicture.asset(
                              Assets.arrow_forward,
                              color: customColors.secondaryButtonContent,
                              height: 10,
                              width: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: SizedBox(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _dayItemBottomSheet({required Color color, required String text}) {
    return Container(
      child: Row(
        children: [
          Container(
            color: color,
            width: 30,
            height: 10,
          ),
          SizedBox(width: 10),
          CustomText(
            text,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  Widget _myProcess() {
    return Container(
        height: 180,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                height: 1,
                width: double.infinity,
                color: customColors.greyBackground,
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24),
                height: double.infinity,
                width: 1,
                color: customColors.greyBackground,
              ),
            ),

            /// gridview
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    childAspectRatio: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    children: [
                      _processItem(
                        image: Assets.totalHabits,
                        title: "${profileHabitCount!.totalHabits} дадал",
                        text: LocaleKeys.totalHabits,
                      ),
                      _processItem(
                        image: Assets.completedHabits,
                        title: "${profileHabitCount!.completedHabits} дадал",
                        text: LocaleKeys.completedHabits,
                      ),
                      _processItem(
                        image: Assets.uncompletedHabits,
                        title: "${profileHabitCount!.uncompletedHabits} дадал",
                        text: LocaleKeys.uncompletedHabits,
                      ),
                      _processItem(
                        image: Assets.failedHabits,
                        title: "${profileHabitCount!.failedHabits} дадал",
                        text: LocaleKeys.failedHabits,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _processItem(
      {required String image, required String title, required String text}) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            image,
            height: 18,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10),
          CustomText(
            title,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          CustomText(
            text,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
