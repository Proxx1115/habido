import 'package:flutter/material.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class SavingsDialogBody extends StatelessWidget {
  final UserHabit userHabit;
  final HabitProgress? habitProgress;
  final Color? primaryColor;
  final Color? backgroundColor;
  final String? title;
  final TextEditingController controller;
  final String? buttonText;

  SavingsDialogBody({
    Key? key,
    required this.userHabit,
    this.habitProgress,
    this.primaryColor,
    this.backgroundColor,
    this.title,
    required this.controller,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Func.hideKeyboard(context);
      },
      child: Container(
        child: Column(
          children: [
            /// Title
            CustomText(title, fontWeight: FontWeight.w500),

            HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

            /// Amount
            CustomTextField(
              controller: controller,
              keyboardType: TextInputType.number,
              backgroundColor: backgroundColor,
              hintText: LocaleKeys.enterAmount,
              maxLength: 15,
            ),

            /// Button add, edit
            CustomButton(
              style: CustomButtonStyle.Secondary,
              margin: EdgeInsets.only(top: 20.0),
              text: buttonText,
              backgroundColor: primaryColor,
              alignment: Alignment.center,
              onPressed: () {
                Func.hideKeyboard(context);

                if (controller.text.isNotEmpty) {
                  if (habitProgress != null) {
                    // Edit
                    var hp = habitProgress!;
                    hp.value = controller.text;

                    BlocManager.userHabitBloc.add(UpdateHabitProgressEvent(hp));
                  } else {
                    // Add
                    var hp = HabitProgress()
                      ..progressId = 0
                      ..planId = 0
                      ..progressCatId = 0
                      ..answerId = 0
                      ..userHabitId = userHabit.userHabitId;

                    hp.value = controller.text;

                    BlocManager.userHabitBloc.add(AddHabitProgressEvent(hp));
                  }
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
