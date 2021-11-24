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
import 'emoji_widget_for_feeling_note.dart';

class HabitFeelingRoute extends StatefulWidget {
  final UserHabit userHabit;
  final VoidCallback? callBack;

  const HabitFeelingRoute({
    Key? key,
    required this.userHabit,
    this.callBack,
  }) : super(key: key);

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

  // Conclusion
  final _conclusionController = TextEditingController();
  String? _conclusion = '';

  // Button
  bool _enabledButton = false;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    // UI
    _primaryColor = HabitHelper.getPrimaryColor1(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor1(_userHabit);

    _conclusionController.addListener(() {
      _enabledButton = _conclusionController.text.isNotEmpty;
    });

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
                padding: SizeHelper.screenPadding,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          /// Emoji
                          _userHabit.habit?.goalSettings?.toolContent?.isFeeling == null ?
                          EmojiWidget(
                            onSelectedEmoji: (value) {
                              setState(() {
                                _selectedEmoji = value;
                              });
                            },
                          ) : EmojiWidgetForFeelingNote(
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
    } else if (state is UpdateUserHabitSuccess) {
      if (state.userHabit.userHabitId == _userHabit.userHabitId) {
        _userHabit = state.userHabit;
      }
    } else if (state is UpdateUserHabitFailed) {
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
      style: CustomButtonStyle.secondary,
      backgroundColor: _primaryColor,
      text: LocaleKeys.finish,
      onPressed: (_selectedEmoji != null && Func.isNotEmpty(_userHabit.userNote))
          ? () {
              var request = SaveUserHabitProgressRequest();
              request.userHabitId = _userHabit.userHabitId;
              request.value = Func.toStr(_selectedEmoji!);
              request.note = _userHabit.userNote;
              BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
            }
          : null,
    );
  }
}
