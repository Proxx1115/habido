import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/habit/habit_card.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/models/habit.dart';

class SignUpQuestionRoute extends StatefulWidget {
  const SignUpQuestionRoute({Key? key}) : super(key: key);

  @override
  State<SignUpQuestionRoute> createState() => _SignUpQuestionRouteState();
}

class _SignUpQuestionRouteState extends State<SignUpQuestionRoute> {
  // Main
  final _signUpQuestionKey = GlobalKey<ScaffoldState>();

  // PageView
  PageController _pageController = PageController();
  int _currentIndex = 0;
  List<String> assetList = [Assets.question1, Assets.question2, Assets.question3];
  List<String> _selectedAnswers1 = [];
  String _selectedAnswers2 = "";
  Habit? _habit;
  double _height = 0.0;
  double _minHeight = 600;

  _onSelectAnswer1(String value) {
    if (_selectedAnswers1.contains(value)) {
      _selectedAnswers1.remove(value);
    } else {
      if (_selectedAnswers1.length == 0 || _selectedAnswers1.length == 1 || _selectedAnswers1.length == 2) {
        //todo fix
        _selectedAnswers1.add(value);
      }
    }
  }

  _onSelectAnswer2(String value) {
    _selectedAnswers2 = value;
    print(_selectedAnswers2);
    nextPage();
  }

  nextPage() {
    _pageController.animateToPage(_currentIndex + 1, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: customColors.primaryBackground,
      scaffoldKey: _signUpQuestionKey,
      child: Stack(
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
      ),
    );
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
                      margin: EdgeInsets.fromLTRB(SizeHelper.margin, 30.0, SizeHelper.margin, SizeHelper.margin),
                      child: _indicator(_currentIndex),
                    ),

                    SizedBox(height: 40.0),

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
                          onPressed: _selectedAnswers1.length != 0
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

  Widget _answerItem1(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          _onSelectAnswer1(text);
        });
      },
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: customColors.primary, width: 1),
          borderRadius: BorderRadius.circular(20.0),
          color: _selectedAnswers1.contains(text) ? customColors.primary : customColors.whiteBackground,
        ),
        child: Text(
          // todo change to CustomText
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _selectedAnswers1.contains(text) ? customColors.whiteText : customColors.primaryText,
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  Widget _answerItem2(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          _onSelectAnswer2(text);
        });
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: customColors.primary, width: 1),
          borderRadius: BorderRadius.circular(20.0),
          color: _selectedAnswers2 == (text) ? customColors.primary : customColors.whiteBackground,
        ),
        child: CustomText(
          text,
          color: _selectedAnswers2 == text ? customColors.whiteText : customColors.primaryText,
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
      margin: const EdgeInsets.fromLTRB(SizeHelper.margin, 0, SizeHelper.margin, SizeHelper.margin),
      child: Column(
        children: [
          CustomText(
            LocaleKeys.signUpQuest1,
            alignment: Alignment.center,
            textAlign: TextAlign.center,
            color: customColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 19.0,
            maxLines: 2,
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
          ),
          SizedBox(height: 28.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 25.0,
            runSpacing: 20.0,
            children: [
              for (var el in LocaleKeys.signUpQuest1Answers) _answerItem1(el),
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
            maxLines: 2,
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
          ),
          SizedBox(height: 28.0),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25.0,
            runSpacing: 20.0,
            children: [
              for (var el in LocaleKeys.signUpQuest2Answers) _answerItem2(el),
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
