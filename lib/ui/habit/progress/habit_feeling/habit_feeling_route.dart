import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
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

class HabitFeelingRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitFeelingRoute({Key? key, required this.userHabit}) : super(key: key);

  @override
  _HabitFeelingRouteState createState() => _HabitFeelingRouteState();
}

class _HabitFeelingRouteState extends State<HabitFeelingRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Emoji
  int? _selectedEmoji;

  // Data
  late UserHabit _userHabit;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

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
                          /// Emoji
                          EmojiWidget(
                            onSelectedEmoji: (value) {
                              setState(() {
                                _selectedEmoji = value;
                              });
                            },
                          ),

                          /// Note
                          NoteWidget(
                            userHabit: _userHabit,
                            margin: EdgeInsets.only(top: 15.0),
                          ),

                          /// Content
                          if (_userHabit.habit?.contentId != null)
                            SuggestedContent(
                              contentId: _userHabit.habit!.contentId!,
                              margin: EdgeInsets.only(top: 30.0),
                            ),
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
      BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'habitProgressResponse': state.habitProgressResponse,
        'primaryColor': _primaryColor,
        // 'callback': () {
        //   Navigator.popUntil(context, ModalRoute.withName(Routes.home));
        // }
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is UpdateUserHabitSuccess) {
      if (state.userHabit.userHabitId == _userHabit.userHabitId) {
        _userHabit = state.userHabit;
      }
      BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
    } else if (state is SaveUserHabitProgressFailed) {
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
