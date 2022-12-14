import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/mood_tracker_bloc.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/ui/feeling/emoji_item_widget.dart';
import 'package:habido_app/ui/feeling/btn_next_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingMainRoute extends StatefulWidget {
  const FeelingMainRoute({Key? key}) : super(key: key);

  @override
  State<FeelingMainRoute> createState() => _FeelingMainRouteState();
}

class _FeelingMainRouteState extends State<FeelingMainRoute> {
  // UI
  final _feelingMainKey = GlobalKey<ScaffoldState>();

  MoodTrackerAnswer? _selectedFeelingData;

  MoodTrackerQuestionResponse? _moodTrackerQuestion;

  @override
  void initState() {
    super.initState();
    BlocManager.moodTrackerBloc.add(GetMoodTrackerQuestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.moodTrackerBloc,
      child: BlocListener<MoodTrackerBloc, MoodTrackerState>(
        listener: _blocListener,
        child: BlocBuilder<MoodTrackerBloc, MoodTrackerState>(builder: (context, state) {
          return BlocBuilder<MoodTrackerBloc, MoodTrackerState>(
            builder: _blocBuilder,
          );
        }),
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, MoodTrackerState state) {
    var _size = MediaQuery.of(context).size;

    return CustomScaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 30.0,
        ),
        child: ButtonNextWidget(onTap: _navigateToFeelingEmojiRoute, progressValue: 0.25),
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      child: (_moodTrackerQuestion != null && _selectedFeelingData != null)
          ? SingleChildScrollView(
              child: Container(
                height: _size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [HexColor.fromHex(_selectedFeelingData!.topColor!), HexColor.fromHex(_selectedFeelingData!.bottomColor!)],
                  ),
                ),
                child: Column(
                  children: [
                    if (!Platform.isAndroid)
                      SizedBox(
                        height: 36,
                      ),

                    _closeBtn(),

                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          /// Question
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: _size.width * 0.2),
                            child: CustomText(
                              _moodTrackerQuestion!.questionText,
                              color: customColors.whiteText,
                              alignment: Alignment.center,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0,
                              maxLines: 2,
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: _selectedFeelingData!.answerImageUrl!,
                                  // placeholder: (context, url) => CustomLoader(context, size: 20.0),
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) => Container(),
                                  height: _size.height * 0.15,
                                  fit: BoxFit.contain,
                                ),

                                SizedBox(height: 14.0),

                                /// Feeling Name
                                CustomText(
                                  _selectedFeelingData!.answerText,
                                  color: customColors.whiteText,
                                  alignment: Alignment.center,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Feelings list
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: 300,
                        child: Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          alignment: WrapAlignment.center,
                          children: [
                            for (var i = 0; i < _moodTrackerQuestion!.answers!.length; i++)
                              EmojiItemWidget(
                                emojiData: _moodTrackerQuestion!.answers![i],
                                isSelected: _selectedFeelingData == _moodTrackerQuestion!.answers![i],
                                isBold: true,
                                onTap: () {
                                  setState(() {
                                    _selectedFeelingData = _moodTrackerQuestion!.answers![i];
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
      scaffoldKey: _feelingMainKey,
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

  void _blocListener(BuildContext context, MoodTrackerState state) {
    if (state is MoodTrackerQuestSuccess) {
      _moodTrackerQuestion = state.moodTrackerQuestion;
      _selectedFeelingData = _moodTrackerQuestion!.answers![0];
    } else if (state is MoodTrackerQuestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
    if (state is MoodTrackerSaveSuccess) {
      MoodTrackerQuestionResponse _moodTrackerQuestionResponse = state.moodTrackerQuestion;
      Navigator.pushNamed(
        context,
        Routes.feelingEmoji,
        arguments: {
          'moodTrackerQuestionResponse': _moodTrackerQuestionResponse,
          'selectedFeelingData': _selectedFeelingData,
        },
      );
    } else if (state is MoodTrackerSaveFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _navigateToFeelingEmojiRoute() {
    List<MoodTrackerSaveAnswer> answers = [];
    var answer = MoodTrackerSaveAnswer(answerId: _selectedFeelingData!.feelinQuestionAnsId, text: _selectedFeelingData!.answerText);
    answers.add(answer);

    var request = MoodTrackerSaveRequest()
      ..questionId = _moodTrackerQuestion!.feelingQuestionId
      ..userFeelingId = _moodTrackerQuestion!.userFeelingId
      ..answers = answers;

    BlocManager.moodTrackerBloc.add(SaveMoodTrackerEvent(request));
  }
}
