import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_new_bloc.dart';
import 'package:habido_app/bloc/mood_tracker_bloc.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingDetailRoute extends StatefulWidget {
  final MoodTrackerAnswer? selectedFeelingData;
  final List<MoodTrackerAnswer>? selectedCauses;
  final MoodTrackerQuestionResponse? moodTrackerQuestionResponse;
  const FeelingDetailRoute({
    Key? key,
    this.selectedFeelingData,
    this.selectedCauses,
    this.moodTrackerQuestionResponse,
  }) : super(key: key);

  @override
  State<FeelingDetailRoute> createState() => _FeelingDetailRouteState();
}

class _FeelingDetailRouteState extends State<FeelingDetailRoute> {
  // UI
  final _feelingDetailKey = GlobalKey<ScaffoldState>();

  // Мэдрэмжийн дэлгэрэнгүй
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.moodTrackerBloc,
      child: BlocListener<MoodTrackerBloc, MoodTrackerState>(
        listener: _blocListener,
        child: BlocBuilder<MoodTrackerBloc, MoodTrackerState>(builder: (context, state) {
          return CustomScaffold(
            onWillPop: () async => false,
            extendBodyBehindAppBar: true,
            scaffoldKey: _feelingDetailKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, SizeHelper.margin, 0.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [customColors.feelingCauseTop, customColors.feelingCauseBtm],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _closeBtn(),

                        SizedBox(height: 28.0),

                        /// Question
                        Container(
                          child: CustomText(
                            widget.moodTrackerQuestionResponse!.questionText,
                            color: customColors.whiteText,
                            fontWeight: FontWeight.w700,
                            fontSize: 27.0,
                            maxLines: 3,
                          ),
                        ),

                        SizedBox(height: 25.0),

                        /// Feeling Item
                        _feelingItem(),

                        SizedBox(height: 14.0),

                        _feelingDetailTextField(),
                      ],
                    ),
                  ),

                  // Finish Button
                  _buttonFinish(),

                  SizedBox(height: 30.0)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _causeItem(data) {
    return Container(
      height: 22.0,
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      margin: EdgeInsets.only(right: 7.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: customColors.feelingCauseItem,
      ),
      child: Text(
        data.answerText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: customColors.whiteText,
          fontWeight: FontWeight.w500,
          fontSize: 11.0,
        ),
      ),
    );
  }

  Widget _feelingItem() {
    return Container(
      height: 73.0,
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: customColors.feelingCauseLight,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.selectedFeelingData!.answerImageUrl!,
            // placeholder: (context, url) => CustomLoader(context, size: 20.0),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Container(),
            height: 50.0,
            width: 50.0,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 18.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  widget.selectedFeelingData!.answerText,
                  color: customColors.whiteText,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var cause in widget.selectedCauses!) _causeItem(cause),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _feelingDetailTextField() {
    return Container(
      height: 186.0,
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 18.0, 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: customColors.feelingCauseLight,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                Assets.male_habido_png,
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: CustomText(
                  LocaleKeys.feelingDetailIntro,
                  fontSize: 11.0,
                  color: customColors.whiteText,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          /// Divider
          HorizontalLine(margin: EdgeInsets.only(top: 9.0)),

          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              cursorColor: customColors.whiteText,
              style: TextStyle(color: customColors.whiteText),
              decoration: InputDecoration(
                hintText: LocaleKeys.feelingDetailHint,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: customColors.whiteText,
                ),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _closeBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home_new));
          },
          child: Container(
            height: 35.0,
            width: 35.0,
            margin: EdgeInsets.fromLTRB(0.0, SizeHelper.margin, SizeHelper.margin, 0.0),
            padding: EdgeInsets.all(13.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: customColors.whiteBackground,
            ),
            child: Image.asset(
              Assets.exit,
            ),
          ),
        )
      ],
    );
  }

  _buttonFinish() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            text: LocaleKeys.finish,
            onPressed: _navigateToHomeRoute,
            borderRadius: BorderRadius.circular(30.0),
            margin: EdgeInsets.symmetric(horizontal: 45.0),
          )
        : Container();
  }

  _navigateToHomeRoute() {
    List<MoodTrackerSaveAnswer> answers = [];

    var answer = MoodTrackerSaveAnswer(answerId: 0, text: _textController.text);
    answers.add(answer);

    var request = MoodTrackerSaveRequest()
      ..questionId = widget.moodTrackerQuestionResponse!.feelingQuestionId
      ..userFeelingId = widget.moodTrackerQuestionResponse!.userFeelingId
      ..answers = answers;

    BlocManager.moodTrackerBloc.add(SaveMoodTrackerEvent(request));
  }

  _navigatePop() {
    Navigator.popUntil(context, ModalRoute.withName(Routes.feelingCause));
  }

  void _blocListener(BuildContext context, MoodTrackerState state) {
    if (state is MoodTrackerSaveSuccess) {
      // Navigator.pushNamed(context, Routes.feelingSuccess, arguments: {
      //   'callback': _saveSuccess(),
      // });
      _showDialog();
    } else if (state is MoodTrackerSaveFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.fromLTRB(45, 0, 45, 30),
          color: customColors.feelingCauseTop.withOpacity(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Platform.isAndroid ? 220 : 240,
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  /// TODO fix background white
                  Center(child: SvgPicture.asset(Assets.group_of_mood, height: 250, width: 261)),
                  // Center(
                  //   child: Opacity(
                  //     opacity: 0.25,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
                  //         color: Colors.white,
                  //       ),
                  //       width: 230.0,
                  //       height: 230.0,
                  //       child: Container(),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 16,
              ),

              CustomText(
                LocaleKeys.thankYouForSharingEmotions,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                maxLines: 3,
                color: customColors.whiteText,
                alignment: Alignment.center,
              ),

              Expanded(child: Container()),

              /// Button finish
              CustomButton(
                text: LocaleKeys.thanksHabiDo,
                style: CustomButtonStyle.primary,
                onPressed: () {
                  BlocManager.homeNewBloc.add(GetAdviceVideoEvent());
                  BlocManager.homeNewBloc.add(GetTipEvent());
                  BlocManager.homeNewBloc.add(GetMoodTrackerEvent());
                  Navigator.popUntil(context, ModalRoute.withName(Routes.home_new));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
