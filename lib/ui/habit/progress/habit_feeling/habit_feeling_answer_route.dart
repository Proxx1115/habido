import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_question_response.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
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
import 'package:habido_app/widgets/text_field/text_fields.dart';

import 'emoji_widget.dart';

class HabitFeelingAnswerRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitFeelingAnswerRoute({Key? key, required this.userHabit}) : super(key: key);

  @override
  _HabitFeelingAnswerRouteState createState() => _HabitFeelingAnswerRouteState();
}

class _HabitFeelingAnswerRouteState extends State<HabitFeelingAnswerRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late UserHabit _userHabit;

  // Question
  HabitQuestion? _question;

  // Answers
  List<HabitAnswer>? _answerList;

  // TextField
  final _conclusionController = TextEditingController();
  String _conclusion = '';

  // Button
  bool _enabledButton = false;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

    if (_userHabit.habit?.questionId != null) {
      BlocManager.userHabitBloc.add(GetHabitQuestionEvent(_userHabit.habit!.questionId!));
    }

    super.initState();

    _conclusionController.addListener(() {
      _conclusion = _conclusionController.text;
      _validateForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userHabitBloc,
      child: BlocListener<UserHabitBloc, UserHabitState>(
        listener: _blocListener,
        child: BlocBuilder<UserHabitBloc, UserHabitState>(
          builder: (context, state) {
            return CustomScaffold(
              appBarTitle: _userHabit.name,
              appBarLeadingColor: _primaryColor,
              backgroundColor: _backgroundColor,
              loading: state is UserHabitProgressLoading,
              child: Column(
                children: [
                  Expanded(
                    child: (_question != null && _answerList != null && _answerList!.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  StadiumContainer(
                                    padding: SizeHelper.boxPadding,
                                    child: Column(
                                      children: [
                                        /// Question
                                        CustomText(_question!.questionText, fontWeight: FontWeight.w500, maxLines: 5),

                                        HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

                                        for (int i = 0; i < _answerList!.length; i++) _listItem(i),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ),

                  /// Button finish
                  _buttonFinish(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is SaveUserHabitProgressSuccess) {
      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'habitProgressResponse': state.habitProgressResponse,
        'primaryColor': _primaryColor,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
    if (state is HabitQuestionSuccess) {
      _question = state.habitQuestionResponse.habitQuestion;
      _answerList = state.habitQuestionResponse.answers;

      if (_answerList != null && _answerList!.isNotEmpty) {
        // _answerList![0].isSelected = true;
      }
    } else if (state is HabitQuestionFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _listItem(int index) {
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 0 : 15.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
          child: ExpansionTile(
            maintainState: false,
            collapsedBackgroundColor: _backgroundColor,
            backgroundColor: _backgroundColor,
            initiallyExpanded: false,
            //index == 0,
            //_answers![index].isSelected,

            /// Title
            title: CustomText(
              _answerList![index].answerText,
              fontWeight: FontWeight.w500,
            ),

            /// Icon
            trailing: Container(
              height: 20.0,
              width: 20.0,
              // padding: EdgeInsets.all(6.0),
              // decoration: BoxDecoration(shape: BoxShape.circle, color: _primaryColor),
              child: SvgPicture.asset(
                _answerList![index].isSelected ? Assets.circle_check : Assets.circle_check,
                color: _answerList![index].isSelected ? _primaryColor : customColors.iconGrey,
              ),
            ),

            /// Progress list
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(width: SizeHelper.borderWidth, color: customColors.primaryBorder),
                ),
                child: Column(
                  children: [
                    /// Дүгнэлт бичих
                    CustomTextField(
                      controller: _conclusionController,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeHelper.borderRadius),
                        topRight: Radius.circular(SizeHelper.borderRadius),
                      ),
                      alwaysVisibleSuffix: true,
                      hintText: LocaleKeys.writeConclusion,
                      maxLines: 5,
                      autofocus: true,
                    ),

                    /// Emoji
                    EmojiWidget(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(SizeHelper.borderRadius),
                        bottomRight: Radius.circular(SizeHelper.borderRadius),
                      ),
                      visibleHeader: false,
                      onSelectedEmoji: (value) {
                        Func.hideKeyboard(context);
                        _answerList![index].selectedEmoji = value;
                        _validateForm();
                      },
                    ),
                  ],
                ),
              ),
            ],
            onExpansionChanged: (bool expanded) {
              // Clear emoji
              _answerList![index].selectedEmoji = null;

              // Answers
              _answerList![index].isSelected = expanded;
              if (expanded) {
                // Clear text
                // _conclusionController.text = '';

                for (int i = 0; i < _answerList!.length; i++) {
                  if (index != i) {
                    _answerList![i].isSelected = false;
                  }
                  // print('$i  ${_answers![i].isSelected}');
                }
              }

              _validateForm();
            },
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    setState(() {
      _enabledButton = _getSelectedAnswer() != null;
    });
  }

  HabitAnswer? _getSelectedAnswer() {
    HabitAnswer? answer;

    if (_answerList != null && _answerList!.isNotEmpty && _question != null) {
      for (var el in _answerList!) {
        if (el.isSelected && Func.isNotEmpty(_conclusion) && el.selectedEmoji != null) {
          answer = el;
        }
      }
    }

    return answer;
  }

  Widget _buttonFinish() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, SizeHelper.marginBottom),
            alignment: Alignment.bottomRight,
            style: CustomButtonStyle.Secondary,
            backgroundColor: _primaryColor,
            text: LocaleKeys.finish,
            onPressed: _enabledButton
                ? () {
                    HabitAnswer? answer = _getSelectedAnswer();

                    if (answer != null) {
                      var request = SaveUserHabitProgressRequest();
                      request.userHabitId = _userHabit.userHabitId;
                      request.value = Func.toStr(answer.selectedEmoji ?? '');
                      request.note = Func.toStr(_conclusion);

                      BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
                    }
                  }
                : null,
          )
        : Container();
  }
}
