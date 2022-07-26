import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/mood_tracker_bloc.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/ui/feeling/btn_back_widget.dart';
import 'package:habido_app/ui/feeling/btn_next_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingCauseRoute extends StatefulWidget {
  final MoodTrackerQuestionResponse? moodTrackerQuestionResponse;
  final MoodTrackerAnswer? selectedFeelingData;
  const FeelingCauseRoute({Key? key, this.selectedFeelingData, this.moodTrackerQuestionResponse}) : super(key: key);

  @override
  State<FeelingCauseRoute> createState() => _FeelingCauseRouteState();
}

class _FeelingCauseRouteState extends State<FeelingCauseRoute> {
  // UI
  final _feelingCauseKey = GlobalKey<ScaffoldState>();

  List<MoodTrackerAnswer> _selectedCauses = [];

  _onSelectCause(MoodTrackerAnswer value) {
    if (_selectedCauses.contains(value)) {
      _selectedCauses.remove(value);
    } else {
      if (_selectedCauses.length < 2) {
        _selectedCauses.add(value);
      }
    }
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
            scaffoldKey: _feelingCauseKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, SizeHelper.margin, 0.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [customColors.feelingCauseTop, customColors.feelingCauseBtm],
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

                  SizedBox(height: 86.0),

                  Expanded(
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 14.0,
                      runSpacing: 8.0,
                      children: [
                        for (var el in widget.moodTrackerQuestionResponse!.answers!) _causeItem(el),
                      ],
                    ),
                  ),

                  ButtonNextWidget(
                    onTap: _navigateToFeelingDetailRoute,
                    isVisible: _selectedCauses.length != 0,
                    progressValue: 0.75,
                  ),

                  SizedBox(height: 30.0)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _causeItem(MoodTrackerAnswer data) {
    return InkWell(
      onTap: () {
        setState(() {
          _onSelectCause(data);
        });
      },
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _selectedCauses.contains(data) ? customColors.primary : customColors.feelingCauseItem,
        ),
        child: Text(
          data.answerText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: customColors.whiteText,
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, MoodTrackerState state) {
    if (state is MoodTrackerSaveSuccess) {
      MoodTrackerQuestionResponse _moodTrackerQuestionResponse = state.moodTrackerQuestion;

      Navigator.pushNamed(
        context,
        Routes.feelingDetail,
        arguments: {
          'selectedFeelingData': widget.selectedFeelingData,
          'selectedCauses': _selectedCauses,
          'moodTrackerQuestionResponse': _moodTrackerQuestionResponse,
        },
      );

      ///
    } else if (state is MoodTrackerSaveFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _navigateToFeelingDetailRoute() {
    List<MoodTrackerSaveAnswer> answers = [];

    for (var el in _selectedCauses) {
      var answer = MoodTrackerSaveAnswer(answerId: el.feelinQuestionAnsId, text: el.answerText);
      answers.add(answer);
    }

    var request = MoodTrackerSaveRequest()
      ..questionId = widget.moodTrackerQuestionResponse!.feelingQuestionId
      ..userFeelingId = widget.moodTrackerQuestionResponse!.userFeelingId
      ..answers = answers;

    BlocManager.moodTrackerBloc.add(SaveMoodTrackerEvent(request));
  }

  _navigatePop() {
    Navigator.popUntil(context, ModalRoute.withName(Routes.feelingEmoji));
  }
}
