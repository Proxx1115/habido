/// result
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/psy_test_review.dart';
import 'package:habido_app/models/test.dart';
import 'package:habido_app/models/test_result.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_containers/info_container_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_bloc_v2/psy_test_bloc_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_containers/suggested_habit_container.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyTestResultRouteV2 extends StatefulWidget {
  final bool isActiveAppBar;
  final int testId;
  final TestResult? testResult;
  const PsyTestResultRouteV2({Key? key, required this.testResult, required this.testId, required this.isActiveAppBar}) : super(key: key);

  @override
  _PsyTestResultRouteV2State createState() => _PsyTestResultRouteV2State();
}

class _PsyTestResultRouteV2State extends State<PsyTestResultRouteV2> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.psyTestBlocV2,
        child: BlocListener<TestsBlocV2, TestsStateV2>(
          listener: _blocListener,
          child: BlocBuilder<TestsBlocV2, TestsStateV2>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, TestsStateV2 state) {
    if (state is TestReviewSuccess) {
      print("Post success review");
    } else if (state is TestReviewFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, TestsStateV2 state) {
    return CustomScaffold(
      appBarTitle: widget.isActiveAppBar == true ? "" : null,
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      },
      child: Container(
        padding: SizeHelper.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Result
            RoundedCornerListView(
              // padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
              children: [
                /// RESULT_INFO
                _testResult(),

                SizedBox(height: 25),

                /// SUGGESTED_HABIT
                if (widget.testResult!.habit != null)
                  Column(
                    children: [
                      /// Title
                      SizedBox(height: 25),
                      CustomText(
                        LocaleKeys.recommendedHabit,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      SizedBox(height: 25),

                      SuggestedHabitContainer(
                        height: 70,
                        title: widget.testResult!.habit!.name ?? '',
                        leadingImageUrl: widget.testResult!.habit!.photo ?? "",
                        // suffixAsset: Assets.arrow_forward,
                        leadingBackgroundColor: HexColor.fromHex("#F1F8E9"), //todo yela onPressed
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName(Routes.home));
                          Navigator.pushNamed(context, Routes.userHabit, arguments: {
                            'screenMode': ScreenMode.New,
                            'habit': widget.testResult!.habit,
                            'title': LocaleKeys.createHabit,
                          });
                        },
                      ),

                      /// Habit item
                      // ListItemContainer(
                      //   margin: EdgeInsets.only(bottom: 15.0),
                      //   height: 70.0,
                      //   leadingImageUrl: widget.testResult!.habit!.photo ?? "",
                      //   title: widget.testResult!.habit!.name ?? '',
                      //   suffixAsset: Assets.arrow_forward,
                      //   leadingBackgroundColor:
                      //       (widget.psyTestResult.habit!.color != null)
                      //           ? HexColor.fromHex(
                      //               widget.psyTestResult.habit!.color!)
                      //           : null,
                      //   onPressed: () {
                      //     Navigator.popUntil(
                      //         context, ModalRoute.withName(Routes.home));
                      //     Navigator.pushNamed(context, Routes.userHabit,
                      //         arguments: {
                      //           'screenMode': ScreenMode.New,
                      //           'habit': widget.psyTestResult.habit,
                      //           'title': LocaleKeys.createHabit,
                      //         });
                      //   },
                      // ),
                    ],
                  ),
              ],
            ),

            /// Button
            CustomButton(
              margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
              text: LocaleKeys.thanksHabido,
              onPressed: () {
                BlocManager.psyTestBlocV2.add(GetTestListEvent());
                Navigator.popUntil(context, ModalRoute.withName(Routes.home));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _testResult() {
    return InfoContainerV2(
      title: widget.testResult!.resultText!,
      body: widget.testResult!.text!,
      titleAlignment: Alignment.center,
      textColor: customColors.primary,
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                LocaleKeys.toEvaluate,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
              SizedBox(width: 13),

              /// RATING BAR
              RatingBar(
                itemSize: 16,
                initialRating: widget.testResult!.reviewScore!,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: SvgPicture.asset(
                    Assets.star_full,
                    height: 30,
                    width: 30,
                  ),
                  half: SvgPicture.asset(
                    Assets.star_half_test,
                    height: 16,
                    width: 16,
                  ),
                  empty: SvgPicture.asset(
                    Assets.star_empty,
                    height: 16,
                    width: 16,
                  ),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                ignoreGestures: _ignoreRatingGesture(),
                onRatingUpdate: (rating) {
                  var psyTestReview = PsyTestReview()
                    ..testId = widget.testId
                    ..score = rating;
                  BlocManager.psyTestBlocV2.add(TestReviewEvent(psyTestReview));
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  bool _ignoreRatingGesture() {
    return widget.testResult!.reviewScore != 0;
  }
}
