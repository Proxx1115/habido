import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/onboarding_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/onboarding_answer.dart';
import 'package:habido_app/models/onboarding_question.dart';
import 'package:habido_app/models/onboarding_start_response.dart';
import 'package:habido_app/ui/habit/habit_card.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/models/habit.dart';

class SignUpQuestionRoute extends StatefulWidget {
  const SignUpQuestionRoute({Key? key}) : super(key: key);

  @override
  State<SignUpQuestionRoute> createState() => _SignUpQuestionRouteState();
}

class _SignUpQuestionRouteState extends State<SignUpQuestionRoute> {
  // Bloc
  late OnBoardingBloc _onBoardingBloc;
  List<OnBoardingQuestion>? _questionList;

  // Main
  final _signUpQuestionKey = GlobalKey<ScaffoldState>();

  // PageView
  PageController _pageController = PageController();
  int _currentIndex = 0;
  List<String> assetList = [Assets.question1, Assets.question3, Assets.question3];
  List<OnBoardingAnswer> _selectedAnswers1 = [];
  List<OnBoardingAnswer> _selectedAnswers2 = [];
  Habit? _habit;
  double _height = 0.0;
  double _minHeight = 600;

  _onSelectAnswer1(OnBoardingAnswer value) {
    if (_selectedAnswers1.contains(value)) {
      _selectedAnswers1.remove(value);
    } else {
      if (_selectedAnswers1.length < 3) {
        //todo fix
        _selectedAnswers1.add(value);
      }
    }
  }

  _onSelectAnswer2(OnBoardingAnswer value) {
    _selectedAnswers2.add(value);
    nextPage();
  }

  nextPage() {
    _pageController.animateToPage(_currentIndex + 1, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    _onBoardingBloc = OnBoardingBloc();
    _onBoardingBloc.add(GetOnBoardingEvent());
  }

  @override
  void dispose() {
    _onBoardingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: customColors.primaryBackground,
        scaffoldKey: _signUpQuestionKey,
        child: BlocProvider.value(
          value: _onBoardingBloc,
          child: BlocListener<OnBoardingBloc, OnBoardingState>(
            listener: _blocListener,
            child: BlocBuilder<OnBoardingBloc, OnBoardingState>(builder: (context, state) {
              return (_questionList != null && _questionList!.isNotEmpty)
                  ? Stack(
                      children: [
                        /// PageView
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: PageView(
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (value) {
                              setState(() {
                                _currentIndex = value;
                              });
                            },
                            children: [
                              _pageViewItem(0, 'svg'),
                              _pageViewItem(1, 'svg'),
                              _pageViewItem(2, 'svg'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container();
            }),
          ),
        ));
  }

  _blocListener(BuildContext context, OnBoardingState state) {
    if (state is GetOnBoardingQuestSuccess) {
      _questionList = state.onBoardingStartResponse.questionList;
      print('got questions ${_questionList}');
    } else if (state is GetOnBoardingQuestFailed) {
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
    } else if (state is OnBoardingSaveSuccess) {
    } else if (state is OnBoardingSaveFailed) {
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

  Widget _indicator(int currentIndex) {
    return Container(
      width: double.infinity,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: customColors.grayIndicator,
      ),
      child: Row(children: [
        Expanded(child: _indicatorItem(0)),
        Expanded(child: _indicatorItem(1)),
        Expanded(child: _indicatorItem(2)),
      ]),
    );
  }

  Widget _indicatorItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            _currentIndex == index ? BorderRadius.only(topRight: Radius.circular(2.0), bottomRight: Radius.circular(2.0)) : BorderRadius.zero,
        color: _currentIndex >= index ? customColors.primary : Colors.transparent,
      ),
    );
  }

  Widget _pageViewItem(int index, String assetType) {
    return LayoutBuilder(builder: (context, constraints) {
      if (_height < constraints.maxHeight) _height = constraints.maxHeight;
      if (_height < _minHeight) _height = _minHeight;

      return SingleChildScrollView(
        child: Container(
          height: _height,
          child: Column(
            // controller: _listScrollController,
            children: [
              /// Cover image
              Expanded(
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: assetType == 'svg'
                          ? SvgPicture.asset(
                              assetList[index],
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width,
                            )
                          : Image.asset(
                              assetList[index],
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),

                    /// Indicator
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.fromLTRB(SizeHelper.margin, 30.0, SizeHelper.margin, 40),
                      child: _indicator(_currentIndex),
                    ),

                    /// Content
                    _currentIndex == 0
                        ? _question1()
                        : _currentIndex == 1
                            ? _question2()
                            : _currentIndex == 2
                                ? _question3()
                                : Container()
                  ],
                ),
              ),

              _currentIndex == 0
                  ? Column(
                      children: [
                        _buttonNext(
                          text: LocaleKeys.continueTxt,
                          onPressed: _selectedAnswers1.length == 3
                              ? () {
                                  nextPage();
                                }
                              : null,
                        ),
                        SizedBox(height: 45.0)
                      ],
                    )
                  : _currentIndex == 2
                      ? Column(
                          children: [
                            _buttonNext(
                              text: LocaleKeys.gonnaTryLater,
                              onPressed: () {
                                _navigateToSignUpCompletedRoute();
                              },
                            ),
                            SizedBox(height: 45.0)
                          ],
                        )
                      : Container()
            ],
          ),
        ),
      );
    });
  }

  Widget _answerItem1(OnBoardingAnswer answer) {
    return InkWell(
      onTap: () {
        setState(() {
          _onSelectAnswer1(answer);
        });
      },
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: customColors.primary, width: 1),
          borderRadius: BorderRadius.circular(20.0),
          color: _selectedAnswers1.contains(answer) ? customColors.primary : customColors.whiteBackground,
        ),
        child: Text(
          // todo change to CustomText
          answer.text!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _selectedAnswers1.contains(answer) ? customColors.whiteText : customColors.primaryText,
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  Widget _answerItem2(OnBoardingAnswer answer) {
    return InkWell(
      onTap: () {
        setState(() {
          _onSelectAnswer2(answer);
        });
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: customColors.primary, width: 1),
          borderRadius: BorderRadius.circular(20.0),
          color: _selectedAnswers2.contains(answer) ? customColors.primary : customColors.whiteBackground,
        ),
        child: CustomText(
          answer.text!,
          color: _selectedAnswers2.contains(answer) ? customColors.whiteText : customColors.primaryText,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _question1() {
    return Container(
      margin: const EdgeInsets.fromLTRB(SizeHelper.margin, 0, SizeHelper.margin, 28),
      child: Column(
        children: [
          CustomText(
            _questionList![0].text,
            alignment: Alignment.center,
            textAlign: TextAlign.center,
            color: customColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 19.0,
            maxLines: 3,
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
          ),
          SizedBox(height: 28.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              for (var el in _questionList![0].answers!) _answerItem1(el),
            ],
          ),
        ],
      ),
    );
  }

  Widget _question2() {
    return Container(
      margin: const EdgeInsets.fromLTRB(SizeHelper.margin, 0.0, SizeHelper.margin, SizeHelper.margin),
      child: Column(
        children: [
          CustomText(
            LocaleKeys.signUpQuest2,
            alignment: Alignment.center,
            textAlign: TextAlign.center,
            color: customColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 19.0,
            maxLines: 3,
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
          ),
          SizedBox(height: 28.0),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25.0,
            runSpacing: 20.0,
            children: [
              for (var el in _questionList![1].answers!) _answerItem2(el),
            ],
          ),
        ],
      ),
    );
  }

  Widget _question3() {
    return Container(
      margin: const EdgeInsets.fromLTRB(SizeHelper.margin, 0.0, SizeHelper.margin, SizeHelper.margin),
      child: Column(
        children: [
          /// Question
          CustomText(
            LocaleKeys.signUpQuest3,
            color: customColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 19.0,
            maxLines: 2,
          ),

          SizedBox(height: SizeHelper.margin),

          /// Body
          CustomText(
            LocaleKeys.signUpQuest3Answer,
            color: customColors.primaryText,
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
            maxLines: 4,
          ),

          _habit != null
              ? HorizontalHabitCard(habit: _habit!)
              : Container(
                  child: Text("Habit"),
                ),
        ],
      ),
    );
  }

  _buttonNext({text, onPressed}) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(15.0),
      margin: EdgeInsets.symmetric(horizontal: 45.0),
    );
  }

  _navigateToSignUpCompletedRoute() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.signUpCompleted,
      (Route<dynamic> route) => false,
    );
  }
}
