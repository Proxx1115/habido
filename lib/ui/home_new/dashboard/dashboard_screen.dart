import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/skip_user_habit_request.dart';
import 'package:habido_app/ui/feeling/emoji_item_widget.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/ui/home_new/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/ui/home_new/slider/custom_carousel_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // UI
  final _dashboardKey = GlobalKey<ScaffoldState>();

  // Slider
  double? _sliderHeight;
  double _sliderAspectRatio = 2.0;
  double _sliderTopMargin = 0.0;
  double _indicatorVerticalMargin = 0;

  // User Data
  String? _username;

  // User habits
  List<UserHabit>? _todayUserHabits;

  // bool _isExpandedTodayUserHabits = false;
  List<UserHabit>? _tomorrowUserHabits;
  List _feelingEmojis = [
    Assets.emoji1,
    Assets.emoji2,
    Assets.emoji3,
    Assets.emoji4,
    Assets.emoji5,
  ];

  List _feelingHistoryData = [
    {"emoji": Assets.emoji1, "name": LocaleKeys.emoji1, "date": "2 өдрийн өмнө", "time": "15:00"},
    {"emoji": Assets.emoji2, "name": LocaleKeys.emoji2, "date": "өчигдөр", "time": "15:00"},
    {"emoji": Assets.emoji3, "name": LocaleKeys.emoji3, "date": "өнөөдөр", "time": "15:00"},
  ];

  @override
  void initState() {
    super.initState();
    _username = "Ногооноо";
    BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _dashboardKey,
      backgroundColor: customColors.primaryBackground,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// Header
          _header(),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _listWidget();
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  _header() {
    _sliderHeight = _sliderHeight ?? (MediaQuery.of(context).size.width) / 2;

    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      // backgroundColor: customColors.primaryBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: DashboardAppBar(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        visibleShowCase: true,
      ),
    );
  }

  Widget _listWidget() {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding, SizeHelper.padding, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// Hello
              Row(
                children: [
                  SvgPicture.asset(Assets.emoji1, height: 46.0, width: 46.0),
                  SizedBox(width: 15.0),
                  CustomText(
                    "${LocaleKeys.hi} $_username",
                    fontWeight: FontWeight.w700,
                    fontSize: 22.0,
                  ),
                ],
              ),

              SizedBox(height: 23.0),

              /// You wanna share your Feeling?
              Stack(
                children: [
                  Container(
                    height: 105.0,
                    padding: EdgeInsets.fromLTRB(40.0, 16.0, 40.0, 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        CustomText(
                          LocaleKeys.shareHowYouFeel,
                          fontWeight: FontWeight.w500,
                          alignment: Alignment.center,
                          fontSize: 15.0,
                        ),
                        SizedBox(height: 9.0),

                        /// FeelingItem

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///
                            for (var el in _feelingEmojis)
                              Container(padding: EdgeInsets.symmetric(horizontal: 5.7), child: SvgPicture.asset(el, height: 31.0, width: 31.0))
                          ],
                        )
                      ],
                    ),
                  ),
                  _startBtn()
                ],
              ),

              /// Last 3 Feeling History
              // Row(
              //   children: [
              //     Expanded(
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: [
              //             for (var el in _feelingHistoryData)
              //               Container(
              //                 margin: EdgeInsets.only(right: 6.0),
              //                 child: EmojiItemWithDateWidget(
              //                   emojiData: el,
              //                   onTap: () {
              //                     setState(() {});
              //                   },
              //                 ),
              //               )
              //           ],
              //         ),
              //       ),
              //     ),
              //     _shareFeelingBtn()
              //   ],
              // ),

              /// Divider
              SizedBox(height: 14.5),
              HorizontalLine(),
              SizedBox(height: 14.5),

              /// Habit Tip
              CustomText(
                LocaleKeys.habitTip,
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),

              SizedBox(height: 11.0),

              _habitTipItem(),

              SizedBox(height: 16.0),

              /// Banner
              CustomCarouselSlider(
                aspectRatio: _sliderAspectRatio,
                sliderHeight: _sliderHeight!,
                sliderMargin: EdgeInsets.only(top: _sliderTopMargin),
                indicatorMargin: EdgeInsets.symmetric(vertical: _indicatorVerticalMargin, horizontal: 2.0),
              ),

              SizedBox(height: 12.0),

              /// HabiDo Instructions
              CustomText(
                LocaleKeys.habidoInstruction,
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),

              SizedBox(height: 12.5),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // for(var el in _instructions) // todo dynamic
                    _instructionItem(),
                    _instructionItem(),
                    _instructionItem(),
                    _instructionItem(),
                  ],
                ),
              ),

              SizedBox(height: SizeHelper.padding),
            ],
          )),
    );
  }

  Widget _shareFeelingBtn() {
    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: () {
        _navigateToFeelingMain(context);
      },
      child: DottedBorder(
        dashPattern: [2, 2],
        strokeWidth: 1,
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: Radius.circular(20.0),
        color: customColors.primary,
        child: Container(
          height: 97,
          width: 78,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.20,
                child: Container(
                  height: 95,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: customColors.primary,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    LocaleKeys.wannaShareFeeling,
                    alignment: Alignment.center,
                    textAlign: TextAlign.center,
                    color: customColors.whiteText,
                    fontWeight: FontWeight.w500,
                    fontSize: 9.0,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 18.0,
                    width: 18.0,
                    padding: EdgeInsets.all(4.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: customColors.primary,
                    ),
                    child: SvgPicture.asset(
                      Assets.add,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _habitTipItem() {
    return Container(
      height: 105.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20.0),

          /// Left Section - Image
          SvgPicture.asset(
            Assets.habit_tip,
          ),

          SizedBox(width: 13.0),

          /// Middle Section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Багаас, энгийнэээр эхэл Start small, start simple",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  maxLines: 2,
                ),
                SizedBox(height: 6.3),
                _startTipBtn()
              ],
            ),
          ),

          SizedBox(width: 26.0),

          /// Right Section - Close Button
          Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: () {
                // todo what's should this do
              },
              child: Container(
                height: 35.0,
                width: 35.0,
                padding: EdgeInsets.all(14.0),
                color: Colors.white,
                child: Image.asset(Assets.exit),
              ),
            ),
          ),

          SizedBox(width: 13.5),
        ],
      ),
    );
  }

  Widget _instructionItem() {
    return Container(
      height: 100.0,
      width: 250.0,
      margin: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          Navigator.of(context).pushNamed(Routes.instruction);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10.0),

            /// Image
            Container(
              height: 75.0,
              width: 75.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.teal, // todo dynamic
              ),
              child: Image.asset(Assets.male_habido_png), // todo
            ),
            SizedBox(width: 10.5),

            /// Title
            Expanded(
              child: CustomText(
                "Чатбот хэрхэн ашиглах вэ?", // todo dynamic
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 57.5),
          ],
        ),
      ),
    );
  }

  Widget _startBtn() {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          _navigateToFeelingMain(context);
        },
        child: Container(
          height: 26.0,
          width: 93.0,
          margin: EdgeInsets.only(top: 92.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: customColors.primary,
          ),
          child: CustomText(
            LocaleKeys.start,
            alignment: Alignment.center,
            fontSize: 11.0,
            color: customColors.whiteText,
          ),
        ),
      ),
    );
  }

  Widget _startTipBtn() {
    return InkWell(
      onTap: () {
        // todo
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 25.0,
        width: 88.0,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 1, color: customColors.athensGrayBorder),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.play,
              height: 10,
              color: customColors.primary,
            ),
            SizedBox(width: 5.0),
            CustomText(
              LocaleKeys.starting,
              fontSize: 11.0,
              color: customColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  _navigateToFeelingMain(BuildContext context) {
    Navigator.pushNamed(context, Routes.feelingMain);
  }
}
