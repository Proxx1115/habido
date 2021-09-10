import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/psy_test_main_bloc.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/psy_test_answer.dart';
import 'package:habido_app/models/psy_test_answers_request.dart';
import 'package:habido_app/models/psy_test_question.dart';
import 'package:habido_app/models/psy_test_question_answer.dart';
import 'package:habido_app/ui/psy_test/psy_test/psy_test_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PsyTestRoute extends StatefulWidget {
  final PsyTest psyTest;

  const PsyTestRoute({
    Key? key,
    required this.psyTest,
  }) : super(key: key);

  @override
  _PsyTestRouteState createState() => _PsyTestRouteState();
}

class _PsyTestRouteState extends State<PsyTestRoute> {
  // UI
  final _psyTestKey = GlobalKey<ScaffoldState>();
  late PsyTestBloc _psyTestBloc;

  // Data
  int? _testId;
  int? _userTestId;
  List<PsyTestQuestion>? _questionList;

  // Page view
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _psyTestBloc = PsyTestBloc();
    _psyTestBloc.add(GetPsyTestQuestionsEvent(widget.psyTest.testId ?? -99));
  }

  @override
  void dispose() {
    _psyTestBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _psyTestKey,
      appBarTitle: widget.psyTest.name,
      appBarOnPressedLeading: _onBackPressed,
      onWillPop: _onBackPressed,
      child: BlocProvider.value(
        value: _psyTestBloc,
        child: BlocListener<PsyTestBloc, PsyTestState>(
          listener: _blocListener,
          child: BlocBuilder<PsyTestBloc, PsyTestState>(
            builder: (context, state) {
              return Container(
                padding: SizeHelper.paddingScreen,
                child: (_questionList != null && _questionList!.isNotEmpty)
                    ? Column(
                        children: [
                          /// Indicator
                          _indicator(),

                          /// PageView
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              children: List.generate(_questionList!.length, (index) => _pageViewItem(index)),
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    :

                    /// Holder
                    Container(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PsyTestState state) {
    if (state is PsyQuestionsSuccess) {
      _testId = state.response.testId;
      _userTestId = state.response.userTestId;
      _questionList = state.response.questionList;
      print('got questions');
    } else if (state is PsyQuestionsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    } else if (state is PsyTestAnswersSuccess) {
      // Refresh dashboard
      BlocManager.psyTestMainBloc.add(GetPsyTestResultsEvent());

      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.psyTestSuccess,
          buttonText: LocaleKeys.seeResult,
          onPressedButton: () {
            Navigator.pushReplacementNamed(context, Routes.psyTestResult, arguments: {
              'psyTestResult': state.psyTestResult,
            });
          },
        ),
      );
    } else if (state is PsyTestAnswersFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  _onBackPressed() {
    if (_currentIndex == 0) {
      Navigator.pop(context);
    } else {
      _pageController.animateToPage(_currentIndex - 1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Widget _indicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: LinearPercentIndicator(
        padding: EdgeInsets.symmetric(horizontal: 7),
        lineHeight: 5,
        progressColor: customColors.primary,
        backgroundColor: Colors.white,
        percent: 1 / _questionList!.length * (_currentIndex + 1),
      ),
    );
  }

  Widget _pageViewItem(int questionIndex) {
    var psyTestQuestion = _questionList![questionIndex];

    return Column(
      children: [
        /// Question
        CustomText(
          psyTestQuestion.text,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 50.0),
        ),

        /// Answers
        Expanded(
          child: (psyTestQuestion.testAnswers != null && psyTestQuestion.testAnswers!.isNotEmpty)
              ? ListView(
                  children:
                      List.generate(psyTestQuestion.testAnswers!.length, (index) => _answerItem(questionIndex, index)),
                )
              : Container(),
        ),

        /// Button next
        _buttonNext(questionIndex),
      ],
    );
  }

  Widget _answerItem(int questionIndex, int answerIndex) {
    PsyTestAnswer answer = _questionList![questionIndex].testAnswers![answerIndex];

    return SelectableListItem(
      text: answer.text,
      isSelected: _questionList![questionIndex].testAnswers![answerIndex].isSelected,
      margin: EdgeInsets.only(top: 15.0),
      onPressed: (isSelected) {
        setState(() {
          _questionList![questionIndex].testAnswers![answerIndex].isSelected = isSelected;

          // Unselect others
          if (isSelected) {
            for (int i = 0; i < _questionList![questionIndex].testAnswers!.length; i++) {
              if (i != answerIndex) {
                _questionList![questionIndex].testAnswers![i].isSelected = false;
              }
            }
          }
        });
      },
    );
  }

  Widget _buttonNext(int questionIndex) {
    // Check enabled button
    bool enabledButton = false;
    for (var el in _questionList![questionIndex].testAnswers!) {
      if (el.isSelected ?? false) {
        enabledButton = true;
        break;
      }
    }

    return CustomButton(
      style: CustomButtonStyle.Secondary,
      text: LocaleKeys.next,
      onPressed: enabledButton
          ? () {
              if (_currentIndex != (_questionList!.length - 1)) {
                // Navigate to next page
                _pageController.animateToPage(
                  _currentIndex + 1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                // Prepare answers
                List<PsyTestQuestionAnswer>? _answerList = [];
                for (var question in _questionList!) {
                  for (var answer in question.testAnswers!) {
                    if (answer.isSelected ?? false) {
                      var psyTestQuestionAnswer = PsyTestQuestionAnswer()
                        ..questionId = question.questionId
                        ..answerId = answer.answerId;

                      _answerList.add(psyTestQuestionAnswer);
                      break;
                    }
                  }
                }

                // Send request
                var request = PsyTestAnswersRequest()
                  ..userTestId = _userTestId
                  ..testId = _testId
                  ..dataTestQuestionAns = _answerList;

                _psyTestBloc.add(SendPsyTestAnswersEvent(request));
              }
            }
          : null,
    );
  }
}
