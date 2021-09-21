import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_question_response.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/content/suggested_content.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/note_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

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

  // Questions
  HabitQuestionResponse? _habitQuestion;

  // Emoji
  int? _selectedEmoji;

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
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          //

                          // _habitQuestionsWithAnswers
                        ],
                      ),
                    ),

                    /// Button finish
                    _buttonFinish(),
                  ],
                ),
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
      _habitQuestion = state.habitQuestionResponse;
    } else if (state is HabitQuestionFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _buttonFinish() {
    return CustomButton(
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: _selectedEmoji != null
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = _userHabit.userHabitId;
              request.value = Func.toStr(_selectedEmoji!);
              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
