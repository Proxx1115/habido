import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/home_new_bloc.dart';
import 'package:habido_app/models/advice_video_response.dart';
import 'package:habido_app/models/mood_tracker.dart';
import 'package:habido_app/models/tip%20category.dart';
import 'package:habido_app/models/tip.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/ui/home_new/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/ui/home_new/slider/custom_carousel_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/video_player/video_player.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // UI
  final _dashboardKey = GlobalKey<ScaffoldState>();

  late AdviceVideoResponse adviceVideoResponse;

  // Slider
  double? _sliderHeight;
  double _sliderAspectRatio = 2.0;
  double _sliderTopMargin = 0.0;
  double _indicatorVerticalMargin = 0;

  List _feelingEmojis = [
    Assets.emoji1,
    Assets.emoji2,
    Assets.emoji3,
    Assets.emoji4,
    Assets.emoji5,
  ];

  AdviceVideoResponse? _adviceVideo;

  List<TipCategory>? _tips;

  List<MoodTracker>? _moodTrackerList;

  @override
  void initState() {
    super.initState();
    BlocManager.homeNewBloc.add(GetAdviceVideoEvent());
    BlocManager.homeNewBloc.add(GetTipEvent());
    BlocManager.homeNewBloc.add(GetMoodTrackerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _dashboardKey,
      backgroundColor: customColors.primaryBackground,
      child: BlocProvider.value(
        value: BlocManager.homeNewBloc,
        child: BlocListener<HomeNewBloc, HomeNewState>(
          listener: _blocListener,
          child: BlocBuilder<HomeNewBloc, HomeNewState>(builder: (context, state) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                /// Home App Bar
                _homeAppBar(),

                /// Rest of items
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return _listWidget();
                    },
                    childCount: 1,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
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
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.5, 0.0),
        visibleShowCase: true,
      ),
    );
  }

  Widget _listWidget() {
    _sliderHeight = _sliderHeight ?? (MediaQuery.of(context).size.width - SizeHelper.margin * 2) / 2;

    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding, SizeHelper.padding, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Hello
            NoSplashContainer(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.userInfo);
                },
                child: Row(
                  children: [
                    _profilePicture(),
                    SizedBox(width: 15.0),

                    /// Name
                    CustomText(
                      "${LocaleKeys.hi} ${globals.userData!.firstName}",
                      // (globals.userData!.firstName ?? ''),
                      fontWeight: FontWeight.w700,
                      fontSize: 22.0,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 23.0),

            _moodTrackerList != null
                ? (_moodTrackerList!.isEmpty
                    ?

                    /// You wanna share your Feeling?
                    Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 28.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: customColors.whiteBackground,
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
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.7), child: SvgPicture.asset(el, height: 31.0, width: 31.0))
                                  ],
                                )
                              ],
                            ),
                          ),
                          _startBtn()
                        ],
                      )
                    :

                    /// Mood Tracker List
                    Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                for (var i = 0; i < _moodTrackerList!.length; i++)
                                  Expanded(
                                      child: _moodTrackerItem(
                                          index: i,
                                          onTap: () {
                                            Navigator.pushNamed(context, Routes.sensitivityNotes);
                                          })),
                                for (var i = 0; i < 3 - _moodTrackerList!.length; i++) Expanded(child: _moodTrackerNoActivity())
                              ],
                            ),
                          ),
                          Expanded(child: _shareFeelingBtn())
                        ],
                      ))
                : Container(
                    height: 97.0,
                  ),

            /// Divider
            SizedBox(height: 14.5),
            HorizontalLine(),
            SizedBox(height: 14.5),

            /// Habit Advice
            CustomText(
              LocaleKeys.habitAdvice,
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

            /// HabiDo tips
            CustomText(
              LocaleKeys.habidoTip,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),

            SizedBox(height: 12.5),

            _tips != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        _tips!.length,
                        (index) => _tipItem(index),
                      ),
                    ),
                  )
                : Container(),

            SizedBox(height: SizeHelper.padding),
          ],
        ),
      ),
    );
  }

  Widget _shareFeelingBtn() {
    return Container(
      margin: EdgeInsets.only(left: 6.0),
      child: InkWell(
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
          padding: EdgeInsets.zero,
          color: customColors.primary,
          child: Container(
            height: 97,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.20,
                  child: Container(
                    height: 95,
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
                  _adviceVideo != null ? _adviceVideo!.title : "",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  maxLines: 2,
                ),
                SizedBox(height: 6.3),
                _startAdviceBtn()
              ],
            ),
          ),

          SizedBox(width: 26.0),

          /// Right Section - Close Button
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: InkWell(
          //     onTap: () {
          //       ///
          //     },
          //     child: Container(
          //       height: 35.0,
          //       width: 35.0,
          //       padding: EdgeInsets.all(14.0),
          //       color: Colors.white,
          //       child: Image.asset(Assets.exit),
          //     ),
          //   ),
          // ),

          SizedBox(width: 13.5),
        ],
      ),
    );
  }

  Widget _tipItem(index) {
    TipCategory tipData = _tips![index];
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
          Navigator.pushNamed(
            context,
            Routes.tip,
            arguments: {
              'tipCategoryId': tipData.tipCategoryId,
              'categoryName': tipData.categoryName,
            },
          );
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
                color: Colors.teal, // todo dynamic tipData.bgColor!,
              ),
              child: CachedNetworkImage(
                imageUrl: tipData.icon!,
                // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                fit: BoxFit.fill,
              ), // todo
            ),

            ///

            SizedBox(width: 10.5),

            /// Title
            Expanded(
              child: CustomText(
                tipData.categoryName,
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

  Widget _profilePicture() {
    return globals.userData!.photo != null
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            child: CachedNetworkImage(
              imageUrl: globals.userData!.photo!,
              fit: BoxFit.cover,
              width: 46.0,
              height: 46.0,
              placeholder: (context, url) => CustomLoader(size: SizeHelper.boxHeight),
              // placeholder: (context, url, error) => Container(),
              errorWidget: (context, url, error) => Container(),
            ),
          )
        : SvgPicture.asset(
            Assets.male_habido,
            width: 46.0,
            height: 46.0,
          );
  }

  Widget _moodTrackerItem({index, onTap}) {
    MoodTracker _moodTrackerData = _moodTrackerList![index];
    return NoSplashContainer(
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          onTap();
        },
        child: Container(
          height: 97,
          margin: EdgeInsets.only(right: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 10.0),
              CachedNetworkImage(
                imageUrl: _moodTrackerData.imageUrl!,
                // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                height: 37.8,
                width: 37.8,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                fit: BoxFit.contain,
              ),
              SizedBox(height: 4.0),
              CustomText(
                _moodTrackerData.mood,
                alignment: Alignment.center,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                fontSize: 11.0,
              ),
              SizedBox(height: 4.0),
              CustomText(
                Func.dateTimeDifference(_moodTrackerData.dateTime!),
                alignment: Alignment.center,
                textAlign: TextAlign.center,
                fontSize: 9.0,
                color: customColors.disabledText,
              ),
              CustomText(
                Func.toTimeStr(_moodTrackerData.dateTime),
                alignment: Alignment.center,
                textAlign: TextAlign.center,
                fontSize: 9.0,
                color: customColors.disabledText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moodTrackerNoActivity() {
    return Container(
      height: 97,
      margin: EdgeInsets.only(right: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: 10.0),
          SvgPicture.asset(
            Assets.no_activity_yet,
            height: 37.8,
            width: 37.8,
          ),
          SizedBox(height: 4.0),
          CustomText(
            LocaleKeys.noActivityYet,
            color: customColors.disabledText,
            alignment: Alignment.center,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w700,
            fontSize: 11.0,
            maxLines: 2,
          ),
        ],
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

  Widget _startAdviceBtn() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          enableDrag: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            child: VideoPlayer(
              videoURL: _adviceVideo!.video!,
              height: MediaQuery.of(context).size.width * 16 / 9,
            ),
          ),
        );
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

  void _blocListener(BuildContext context, HomeNewState state) {
    if (state is AdviceVideoSuccess) {
      _adviceVideo = AdviceVideoResponse(title: state.title, video: state.video);
    } else if (state is AdviceVideoFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is TipSuccess) {
      _tips = state.tipList;
      print("tips ok ${state.tipList}");
    } else if (state is TipFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is MoodTrackerSuccess) {
      _moodTrackerList = state.moodTrackerList;
      print("moodTrackerList ok ${state.moodTrackerList}");
    } else if (state is MoodTrackerFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  // _navigateToAdviceRoute(BuildContext context) {
  //   Navigator.pushNamed(
  //     context,
  //     Routes.advice,
  //     arguments: {
  //       'adviceVideo': _adviceVideo,
  //     },
  //   );
  // }
}
