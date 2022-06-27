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
import 'package:habido_app/ui/profile_v2/performance/feeling_last.dart';
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

class Performance extends StatefulWidget {
  const Performance({
    Key? key,
  }) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  List _data = [
    {
      "month": 7,
      "days": [
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
      ]
    }
  ];

  List _colorsOpacity = [
    Color(0xff73BBB6).withOpacity(0.2),
    Color(0xff73BBB6).withOpacity(0.4),
    Color(0xff73BBB6).withOpacity(0.6),
    Color(0xff73BBB6).withOpacity(0.8),
    Color(0xff73BBB6),
  ];

  Map _calendar1 = {"color": Color(0xff73BBB6), "text": "Гайхамшиг"};
  Map _calendar2 = {"color": Color(0xff73BBB6).withOpacity(0.8), "text": "Гайхамшиг"};
  Map _calendar3 = {"color": Color(0xff73BBB6).withOpacity(0.6), "text": "Гайхамшиг"};
  Map _calendar4 = {"color": Color(0xff73BBB6).withOpacity(0.4), "text": "Гайхамшиг"};
  Map _calendar5 = {"color": Color(0xff73BBB6).withOpacity(0.2), "text": "Бөглөгүй"};
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

  var weekName = ["Да", "Мя", "Лх", "Пү", "Ба", "Бя", "Ня"];

  @override
  void initState() {
    _calendarDesc = [_calendar1, _calendar2, _calendar3, _calendar4, _calendar5];
    BlocManager.performanceBloc.add(GetMonthlyReasonEvent(DateTime.now().year, DateTime.now().month));
    BlocManager.performanceBloc.add(GetMoodTrackerLatestEvent());
    BlocManager.performanceBloc.add(GetMonthlyStatEvent(DateTime.now().year, DateTime.now().month));

    super.initState();
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

  void _blocListener(BuildContext context, PerformanceState state) {
    if (state is MoodMonthlyReasonSuccess) {
      _specificMoodTrackerReasonResponse = state.specificMoodTrackerReasonResponse;
      // _moodReason = _specificMoodTrackerReasonResponse!.positiveReasons!;
      _moodReason = _specificMoodTrackerReasonResponse!.positiveReasons!;
    } else if (state is ModdMonthlyReasonFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is MoodTrackerLatestSuccess) {
      _moodTracker = state.moodTracker;
      print("eminem:${state.moodTracker}");
    } else if (state is ModdTrackerLatestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is MoodMonthlyStatSuccess) {
      calendarMonthDaysResponse = state.calendarMonthDaysResponse;
    } else if (state is ModdMonthlyStatFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, PerformanceState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomText(
            LocaleKeys.myProcess,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          SizedBox(height: 15),
          calendarMonthDaysResponse != null ? _calender() : Container(),
          SizedBox(height: 15),
          _myProcess(),
          SizedBox(height: 15),
          CustomText(
            LocaleKeys.myFeeling,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          SizedBox(height: 15),
          _myFeeling(),
          SizedBox(height: 15),
          // _calender(),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.sensitivityNotes);
            },
            child: Container(
              alignment: Alignment.bottomRight,
              child: Text(
                "Түүх харах",
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
          _moodTracker.length != 0
              ? FeelingLast(
                  answerImageUrl: '${_moodTracker![0].answerImageUrl}',
                  answerText: '${_moodTracker![0].answerText!}',
                  reasons: _moodTracker![0].reasons!,
                  writtenAnswer: '${_moodTracker![0].writtenAnswer!}',
                  bottomDate: '${_moodTracker![0].date!}',
                  maxLines: 2,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _myProcess() {
    return Container(
        height: 180,
        padding: EdgeInsets.symmetric(vertical: 10),
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
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    children: [
                      _processItem(
                        index: 0,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                      _processItem(
                        index: 1,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                      _processItem(
                        index: 2,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                      _processItem(
                        index: 3,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _processItem({required int index, required String title, required String text}) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/profile/process${index}.svg',
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
                                  _moodReason = _specificMoodTrackerReasonResponse!.positiveReasons!;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: positive ? customColors.primary : Colors.transparent,
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
                                    _moodReason = _specificMoodTrackerReasonResponse!.negativeReasons!;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: positive ? Colors.transparent : customColors.primary,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).wp(2), vertical: ResponsiveFlutter.of(context).hp(2)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: ResponsiveFlutter.of(context).hp(21),
        // color: Colors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 15,
                  width: 15,
                ),
                CustomText(
                  "4 сар",
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
                                  "Тухайн өдрийн мэдрэмжийг өнгөөр илтгэн харуулж байгаа юм.",
                                  maxLines: 2,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  // margin: EdgeInsets.only(bottom: 20.0),
                                ),
                              CustomText(
                                "Жишээ нь: Тухайн өдөр “Мэдэхгүй ээ”, “Онцгүй байсан” гэх мэтээр тэмдэглэвэл бүдэг өнгөөр, харин аз “Гайхалтай”, “Дажгүй шүү” гэж бүртгэх тусам өнгө нь тодрох юм. ",
                                maxLines: 5,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                // margin: EdgeInsets.only(bottom: 20.0),
                              ),
                              CustomText(
                                "Ингэснээр сарын сүүлээр өөрийн тухайн сарын сэтгэл зүйн байдлаа  ажиглах боломжтой юм.",
                                maxLines: 5,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                // margin: EdgeInsets.only(bottom: 20.0),
                              ),
                              SizedBox(height: 20),
                              // Column(
                              //   children: [],
                              // )
                              for (var i = 0; i < _calendarDesc.length; i++)
                                _dayItemBottomSheet(color: _calendarDesc[i]['color'], text: _calendarDesc[i]['text']),
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
                    child: SvgPicture.asset(Assets.warning_calendar))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: SvgPicture.asset(
                  Assets.arrow_back,
                  color: customColors.secondaryButtonContent,
                  height: 10,
                  width: 10,
                )),
                Expanded(
                  flex: 9,
                  child: Container(
                    width: ResponsiveFlutter.of(context).hp(7.4),
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          // width: 231,
                          // width: double.infinity,
                          height: ResponsiveFlutter.of(context).hp(13),
                          child: Wrap(
                            spacing: 3.0,
                            runSpacing: 3.0,
                            children: [
                              for (var i = 0; i < calendarMonthDaysResponse!.days!.length; i++) _dayItem(Colors.red),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   child: Container(
                        //     margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        //     // width: 231,
                        //     width: double.infinity,
                        //     height: ResponsiveFlutter.of(context).hp(13),
                        //     child: Wrap(
                        //       spacing: 3.0,
                        //       runSpacing: 3.0,
                        //       children: [
                        //         for (var i = 0; i < calendarMonthDaysResponse!.days!.length; i++) _dayItem(Colors.red),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   top: 20,
                        //   left: -5,
                        //   child: orderOfTheRomboNumber(),
                        // ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        //       // width: 231,
                        //       width: double.infinity,
                        //       height: ResponsiveFlutter.of(context).hp(13),
                        //       child: Wrap(
                        //         spacing: 3.0,
                        //         runSpacing: 3.0,
                        //         children: [
                        //           for (var i = 0; i < calendarMonthDaysResponse!.days!.length; i++) _dayItem(Colors.red),
                        //         ],
                        //       ),
                        //     ),
                        //     orderOfTheRomboNumber()
                        //   ],
                        // ),
                        // Positioned(
                        //   left: 20,
                        //   child: Row(
                        //     children: [
                        //       for (var weekName in weekName)
                        //         Row(
                        //           children: [
                        //             Container(
                        //               width: ResponsiveFlutter.of(context).wp(7.5),
                        //               height: ResponsiveFlutter.of(context).hp(2),
                        //               // color: Colors.amber,
                        //               child: CustomText(
                        //                 weekName,
                        //                 alignment: Alignment.center,
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               width: 3,
                        //             )
                        //           ],
                        //         ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(width: 20),
                Expanded(
                  child: SvgPicture.asset(
                    Assets.arrow_forward,
                    color: customColors.secondaryButtonContent,
                    height: 10,
                    width: 10,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget orderOfTheRomboNumber() {
    return Container(
      // width: ResponsiveFlutter.of(context).wp(4.5),
      // height: ResponsiveFlutter.of(context).hp(7.5),
      // margin: EdgeInsets.only(top: 20),
      // color: Colors.blue,
      child: Column(
        children: [
          for (var orderWeek in romboNumber)
            Container(
              width: ResponsiveFlutter.of(context).wp(3),
              height: ResponsiveFlutter.of(context).hp(2),
              // margin: EdgeInsets.only(bottom: 3),
              child: CustomText(
                orderWeek,
                lineSpace: 1,
                fontSize: 11,
                alignment: Alignment.bottomRight,
                // bgColor: Colors.amber,
              ),
            ),
        ],
      ),
    );
  }

  _dayItem(Color color) {
    return Container(
      // margin: EdgeInsets.only(),
      margin: EdgeInsets.only(
        bottom: ResponsiveFlutter.of(context).hp(0.1),
        left: ResponsiveFlutter.of(context).hp(0.1),
      ),
      color: color,
      width: ResponsiveFlutter.of(context).fontSize(4),
      height: ResponsiveFlutter.of(context).fontSize(1.4),
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
}
