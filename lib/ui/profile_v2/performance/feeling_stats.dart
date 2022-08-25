import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/mood_tracker_latest.dart';
import 'package:habido_app/models/mood_tracker_monthly_reason_response.dart';
import 'package:habido_app/models/mood_tracker_monthly_stat_response.dart';
import 'package:habido_app/models/mood_tracker_reason_with_count.dart';
import 'package:habido_app/models/profile_habit_count.dart';
import 'package:habido_app/ui/profile_v2/performance/performance_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:http/http.dart';

class FeelingStats extends StatefulWidget {
  const FeelingStats({Key? key}) : super(key: key);

  @override
  State<FeelingStats> createState() => _FeelingStatsState();
}

class _FeelingStatsState extends State<FeelingStats> {
  var _currentDateTime = DateTime.now();

  List _colorsOpacity = [
    Color(0xff73BBB6).withOpacity(0.2),
    Color(0xff73BBB6).withOpacity(0.2),
    Color(0xff73BBB6).withOpacity(0.4),
    Color(0xff73BBB6).withOpacity(0.6),
    Color(0xff73BBB6).withOpacity(0.8),
    Color(0xff73BBB6),
  ];

  Map _calendar1 = {"color": Color(0xff73BBB6), "text": LocaleKeys.emoji5};
  Map _calendar2 = {
    "color": Color(0xff73BBB6).withOpacity(0.8),
    "text": LocaleKeys.emoji4
  };
  Map _calendar3 = {
    "color": Color(0xff73BBB6).withOpacity(0.6),
    "text": LocaleKeys.emoji3
  };
  Map _calendar4 = {
    "color": Color(0xff73BBB6).withOpacity(0.4),
    "text": LocaleKeys.emoji2
  };
  Map _calendar5 = {
    "color": Color(0xff73BBB6).withOpacity(0.2),
    "text": LocaleKeys.emoji1
  };
  Map _calendar6 = {
    "color": Color(0xff73BBB6).withOpacity(0),
    "text": LocaleKeys.notNoted
  };
  List _calendarDesc = [];

  /// MOOD TRACKER RESPONSE
  MoodTrackerMonthlyReasonResponse? _specificMoodTrackerReasonResponse;
  late MoodTrackerReasonWithCount _moodReason;

  bool isPositive = true;

  /// MOOD TRACKER MONTHLY STAT
  MoodTrackerMonthlyStatResponse? _calendarMonthDays;

  var romboNumber = ["I", "II", "III", "IV", "V"];

  List testArray = [0, 1, 2, 3];

  @override
  void initState() {
    _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month);
    _calendarDesc = [
      _calendar1,
      _calendar2,
      _calendar3,
      _calendar4,
      _calendar5,
      _calendar6
    ];
    _getMonthlyReason();
    super.initState();
  }

  _getMonthlyReason() {
    BlocManager.performanceBloc.add(
        GetMonthlyReasonEvent(_currentDateTime.year, _currentDateTime.month));
    BlocManager.performanceBloc.add(
        GetMonthlyStatEvent(_currentDateTime.year, _currentDateTime.month));
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
    } else if (state is MoodMonthlyStatSuccess) {
      _calendarMonthDays = state.calendarMonthDaysResponse;
    } else if (state is ModdMonthlyStatFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.performanceBloc,
      child: BlocListener<PerformanceBloc, PerformanceState>(
        listener: _blocListener,
        child: BlocBuilder<PerformanceBloc, PerformanceState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, PerformanceState state) {
    return _calendarMonthDays != null
        ? GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                _onLeft();
              } else if (details.primaryVelocity! < 0) {
                _onRight();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _calendar(),
                    HorizontalLine(
                      margin: EdgeInsets.symmetric(horizontal: 12.5),
                    ),
                    _myFeeling(),
                  ],
                )),
          )
        : Container();
  }

  Widget _calendar() {
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
              _monthSelector(),
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
                        flex: 4,
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
                                child: Center(child: Text(_getWeekDay(index))));
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                          ),
                        ),
                        flex: 18,
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
                        child: Column(children: [
                          Expanded(
                            flex: 23,
                            child: Column(
                              children: [
                                for (var orderWeek in romboNumber)
                                  Container(
                                      margin: EdgeInsets.only(
                                        bottom: ResponsiveFlutter.of(context)
                                            .fontSize(0.2),
                                        // right: ResponsiveFlutter.of(context)
                                        //     .fontSize(0.01),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          orderWeek,
                                          lineSpace:
                                              ResponsiveFlutter.of(context)
                                                  .fontSize(0.16),
                                          fontSize: 11,
                                          alignment: Alignment.center,
                                          // bgColor: Colors.amber,
                                        ),
                                      )),
                              ],
                            ),
                          ),
                        ]),
                        flex: 3,
                      ),
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _calendarMonthDays!.days!.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(
                                  ResponsiveFlutter.of(context).fontSize(0.14)),
                              color: _colorsOpacity[Func.toInt(
                                  _calendarMonthDays!.days![index].point!)],
                              // width: ResponsiveFlutter.of(context).wp(2),
                              // height: ResponsiveFlutter.of(context).hp(0.6),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                ResponsiveFlutter.of(context).fontSize(0.303),
                            crossAxisCount: 7,
                          ),
                        ),
                        flex: 14,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 10,
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
                                  isPositive = true;
                                  _moodReason =
                                      _specificMoodTrackerReasonResponse!
                                          .positiveReasons!;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isPositive
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
                                    isPositive = false;
                                    _moodReason =
                                        _specificMoodTrackerReasonResponse!
                                            .negativeReasons!;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isPositive
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
                          "${isPositive ? _specificMoodTrackerReasonResponse!.positiveReasons!.specificMoodTotalCount! : _specificMoodTrackerReasonResponse!.negativeReasons!.specificMoodTotalCount}/${_specificMoodTrackerReasonResponse!.totalMoodCount}",
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

  String _getWeekDay(int week) {
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

  Widget _monthSelector() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _onLeft();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveFlutter.of(context).wp(4),
            ),
            child: SvgPicture.asset(
              Assets.arrow_back,
              color: customColors.secondaryButtonContent,
              height: 10,
              width: 10,
            ),
          ),
        ),
        CustomText(
          "${_calendarMonthDays!.month} сар",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        InkWell(
          onTap: () {
            _onRight();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveFlutter.of(context).wp(4),
            ),
            child: SvgPicture.asset(
              Assets.arrow_forward,
              color: customColors.secondaryButtonContent,
              height: 10,
              width: 10,
            ),
          ),
        ),
      ],
    );
  }

  _onLeft() {
    if (_currentDateTime.month != 1) {
      _currentDateTime = DateTime(
        _currentDateTime.year,
        _currentDateTime.month - 1,
      );
    } else {
      _currentDateTime = DateTime(
        _currentDateTime.year - 1,
        _currentDateTime.month - 1,
      );
    }
    _getMonthlyReason();
  }

  _onRight() {
    if (DateTime.now().month != _currentDateTime.month ||
        DateTime.now().year != _currentDateTime.year) {
      if (_currentDateTime.month != 12) {
        _currentDateTime = DateTime(
          _currentDateTime.year,
          _currentDateTime.month + 1,
        );
      } else {
        _currentDateTime = DateTime(
          _currentDateTime.year + 1,
          _currentDateTime.month + 1,
        );
      }
      _getMonthlyReason();
    }
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
}
