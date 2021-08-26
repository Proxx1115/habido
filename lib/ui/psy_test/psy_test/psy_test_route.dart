import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/psy_test_answer.dart';
import 'package:habido_app/models/psy_test_question.dart';
import 'package:habido_app/ui/psy_test/psy_test/psy_test_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

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
  PageController _controller = PageController();
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
      body: BlocProvider.value(
        value: _psyTestBloc,
        child: BlocListener<PsyTestBloc, PsyTestState>(
          listener: _blocListener,
          child: BlocBuilder<PsyTestBloc, PsyTestState>(
            builder: (context, state) {
              return Container(
                padding: SizeHelper.paddingScreen,
                child: (_questionList != null && _questionList!.isNotEmpty)
                    ?

                    /// PageView
                    PageView(
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(_questionList!.length, (index) => _pageViewItem(index)),
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
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
    }
  }

  Widget _pageViewItem(int questionIndex) {
    var psyTestQuestion = _questionList![questionIndex];

    return Column(
      children: [
        /// Question
        CustomText(psyTestQuestion.text, alignment: Alignment.center),

        /// Answers
        Expanded(
          child: (psyTestQuestion.testAnswers != null && psyTestQuestion.testAnswers!.isNotEmpty)
              ? ListView(
                  children: List.generate(psyTestQuestion.testAnswers!.length, (index) => _answerItem(questionIndex, index)),
                )
              : Container(),
        ),

        /// Button next
        _buttonNext(),
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

  Widget _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      text: LocaleKeys.next,
      onPressed: () {
        //
      },
    );
  }

// Widget _answerItem(ResAnswers answer) {
//   return NoSplashContainer(
//     child: InkWell(
//       onTap: () {
//
//
//         /// Хариулсан
//         if (_currentIndex == _questions.length - 1) {
//           _add(answer);
//           _finishScoring();
//         } else {
//           _add(answer);
//           _controller.animateToPage(_currentIndex + 1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//               color: appColors.containerBackground, border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
//           child: Txt(
//             answer.ansText,
//             style: TxtStyle.bodyText,
//             maxLines: 99,
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
