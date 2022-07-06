import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_question_response.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit_new/progress/habit_feeling/emoji_widget_v2.dart';
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

class HabitFeelingAnswerRouteV2 extends StatefulWidget {
  final UserHabit userHabit;
  final VoidCallback? callBack;

  const HabitFeelingAnswerRouteV2({
    Key? key,
    required this.userHabit,
    this.callBack,
  }) : super(key: key);

  @override
  _HabitFeelingAnswerRouteV2State createState() => _HabitFeelingAnswerRouteV2State();
}

class _HabitFeelingAnswerRouteV2State extends State<HabitFeelingAnswerRouteV2> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late UserHabit _userHabit;
  // Answers
  List<HabitAnswer>? _questionList;
  HabitAnswer? _selectedQuestion;

  // TextField
  final _conclusionController = TextEditingController();
  TextEditingController _reflectionsTextFieldController = TextEditingController();
  String _conclusion = '';

  // Emoji
  int? _selectedEmoji;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor1(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor1(_userHabit);

    if (_userHabit.habit?.questionId != null) {
      BlocManager.userHabitBloc.add(GetHabitQuestionEvent(_userHabit.habit!.questionId!));
    }

    super.initState();

    _conclusionController.addListener(() {
      _conclusion = _conclusionController.text;
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
              appBarTitle: LocaleKeys.reflectionsOftheDay,
              appBarLeadingColor: _primaryColor,
              backgroundColor: _backgroundColor,
              loading: state is UserHabitProgressLoading,
              child: Column(
                children: [
                  Expanded(
                    child: (_questionList != null && _questionList!.isNotEmpty)
                        ? Container(
                            padding: SizeHelper.screenPadding,
                            child: ClipRRect(
                              // borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  StadiumContainer(
                                    padding: EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        CustomText(
                                          _getText(),
                                          fontWeight: FontWeight.w500,
                                          maxLines: 5,
                                        ),
                                        HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),
                                        EmojiWidgetV2(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(SizeHelper.borderRadius),
                                            bottomRight: Radius.circular(SizeHelper.borderRadius),
                                          ),
                                          visibleHeader: false,
                                          onSelectedEmoji: (value) {
                                            Func.hideKeyboard(context);
                                            _selectedEmoji = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  StadiumContainer(
                                    padding: SizeHelper.boxPadding,
                                    child: Column(
                                      children: [
                                        /// Question
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.info,
                                              width: 15.0,
                                              height: 15.0,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            CustomText(
                                              LocaleKeys.answerOneOfThoseQuestion,
                                              fontWeight: FontWeight.w500,
                                              maxLines: 5,
                                              fontSize: 11.0,
                                            ),
                                          ],
                                        ),

                                        HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _selectedQuestion != null
                                                ? Expanded(
                                                    child: CustomText(
                                                      _selectedQuestion!.answerText,
                                                      fontWeight: FontWeight.w500,
                                                      lineSpace: 1.5,
                                                      maxLines: 5,
                                                      fontSize: 13.0,
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Container(),
                                                  ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showCustomDialog(
                                                  context,
                                                  child: CustomDialogBody(
                                                    child: Container(
                                                      height: 300,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            LocaleKeys.chooseYourQuestion,
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.w500,
                                                            color: customColors.primary,
                                                            alignment: Alignment.center,
                                                          ),
                                                          SizedBox(
                                                            height: 30.0,
                                                          ),
                                                          if (_questionList != null)
                                                            for (var el in _questionList!)
                                                              Column(
                                                                children: [
                                                                  InkWell(
                                                                    child: CustomText(
                                                                      el.answerText,
                                                                      fontSize: 13.0,
                                                                    ),
                                                                    onTap: () {
                                                                      el.isSelected = true;
                                                                      _selectedQuestion = el;
                                                                      setState(() {});
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                  HorizontalLine(margin: EdgeInsets.symmetric(vertical: 14.0)),
                                                                ],
                                                              )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 9.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  color: customColors.greyBackground,
                                                ),
                                                height: 24.0,
                                                width: 24.0,
                                                child: SvgPicture.asset(
                                                  Assets.downArrow,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),
                                        CustomTextField(
                                          controller: _reflectionsTextFieldController,
                                          keyboardType: TextInputType.text,
                                          hintText: LocaleKeys.typeNote,
                                        ),
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
        'callback': widget.callBack,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
    if (state is HabitQuestionSuccess) {
      _questionList = state.habitQuestionResponse.answers;
      if (_questionList != null) {
        _selectedQuestion = _questionList![0];
        _selectedQuestion!.isSelected = true;
        setState(() {});
      }

      if (_questionList != null && _questionList!.isNotEmpty) {
        // _questionList![0].isSelected = true;
      }
    } else if (state is HabitQuestionFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  String _getText() {
    switch (_selectedEmoji) {
      case 1:
        return LocaleKeys.emoji1;
      case 2:
        return LocaleKeys.emoji2;
      case 3:
        return LocaleKeys.emoji3;
      case 4:
        return LocaleKeys.emoji4;
      case 5:
        return LocaleKeys.emoji5;
      default:
        return LocaleKeys.feelingAtTheTime;
    }
  }

  Widget _buttonFinish() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            style: CustomButtonStyle.primary,
            backgroundColor: customColors.primary,
            text: LocaleKeys.finish,
            onPressed: _selectedQuestion != null && _reflectionsTextFieldController.text.isNotEmpty && _selectedEmoji != null
                ? () {
                    HabitAnswer? answer = _selectedQuestion;

                    if (answer != null) {
                      var request = SaveUserHabitProgressRequest();

                      request.userHabitId = _userHabit.userHabitId;
                      request.value = Func.toStr(_selectedEmoji!);
                      request.note = Func.toStr(_conclusion);
                      request.answerId = answer.habitQuestionAnsId;

                      BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
                    }
                  }
                : null,
          )
        : Container();
  }
}
