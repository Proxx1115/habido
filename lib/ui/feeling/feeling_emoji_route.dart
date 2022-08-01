import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/mood_tracker_bloc.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/ui/feeling/btn_back_widget.dart';
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

class FeelingEmojiRoute extends StatefulWidget {
  final MoodTrackerAnswer? selectedFeelingData;
  final MoodTrackerQuestionResponse? moodTrackerQuestionResponse;
  const FeelingEmojiRoute({Key? key, this.selectedFeelingData, this.moodTrackerQuestionResponse}) : super(key: key);

  @override
  State<FeelingEmojiRoute> createState() => _FeelingEmojiRouteState();
}

class _FeelingEmojiRouteState extends State<FeelingEmojiRoute> {
  // UI
  final _feelingEmojiKey = GlobalKey<ScaffoldState>();

  MoodTrackerAnswer? _selectedFeelingEmoji;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Gridview - dynamic spacing
    double _crossAxisSpacing = (width - 90.0 * 3 - SizeHelper.margin * 2) / 2;
    double _mainAxisSpacing = _crossAxisSpacing;

    return BlocProvider.value(
      value: BlocManager.moodTrackerBloc,
      child: BlocListener<MoodTrackerBloc, MoodTrackerState>(
        listener: _blocListener,
        child: BlocBuilder<MoodTrackerBloc, MoodTrackerState>(builder: (context, state) {
          return CustomScaffold(
            onWillPop: () async => false,
            scaffoldKey: _feelingEmojiKey,
            extendBodyBehindAppBar: true,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ButtonNextWidget(
                onTap: _navigateToFeelingEmojiRoute,
                isVisible: _selectedFeelingEmoji != null,
                progressValue: 0.50,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            child: Container(
              padding: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, SizeHelper.margin, 0.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor.fromHex(widget.selectedFeelingData!.topColor!), HexColor.fromHex(widget.selectedFeelingData!.bottomColor!)],
              )),
              child: Column(
                children: [
                  // ButtonBackWidget(onTap: _navigatePop),

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

                  SizedBox(height: 39.0),

                  /// Emoji Item List
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(SizeHelper.padding),
                      crossAxisSpacing: 30.0, //_crossAxisSpacing
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      mainAxisSpacing: 30.0, //_mainAxisSpacing
                      children: [
                        for (var i = 0; i < widget.moodTrackerQuestionResponse!.answers!.length; i++)
                          EmojiSecondItemWidget(
                            emojiData: widget.moodTrackerQuestionResponse!.answers![i],
                            isSelected: _selectedFeelingEmoji == widget.moodTrackerQuestionResponse!.answers![i],
                            onTap: () {
                              setState(() {
                                _selectedFeelingEmoji = widget.moodTrackerQuestionResponse!.answers![i];
                              });
                            },
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _blocListener(BuildContext context, MoodTrackerState state) {
    if (state is MoodTrackerSaveSuccess) {
      MoodTrackerQuestionResponse _moodTrackerQuestionResponse = state.moodTrackerQuestion;
      Navigator.pushNamed(
        context,
        Routes.feelingCause,
        arguments: {
          'selectedFeelingData': widget.selectedFeelingData,
          'moodTrackerQuestionResponse': _moodTrackerQuestionResponse,
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
    var answer = MoodTrackerSaveAnswer(answerId: _selectedFeelingEmoji!.feelinQuestionAnsId, text: _selectedFeelingEmoji!.answerText);
    answers.add(answer);

    var request = MoodTrackerSaveRequest()
      ..questionId = widget.moodTrackerQuestionResponse!.feelingQuestionId
      ..userFeelingId = widget.moodTrackerQuestionResponse!.userFeelingId
      ..answers = answers;

    BlocManager.moodTrackerBloc.add(SaveMoodTrackerEvent(request));
  }

  _navigatePop() {
    Navigator.popUntil(context, ModalRoute.withName(Routes.feelingMain));
  }
}
