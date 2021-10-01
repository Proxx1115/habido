import 'package:flutter/material.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_expense_category.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/combobox/combo_helper.dart';
import 'package:habido_app/widgets/combobox/combobox.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:habido_app/widgets/text_field/text_input_formatter.dart';

class ExpenseDialogBody extends StatefulWidget {
  final UserHabit userHabit;
  final HabitProgress? habitProgress;
  final List<ComboItem> habitExpenseCategoryComboList;
  final Color? primaryColor;
  final Color? backgroundColor;
  final String? title;
  final TextEditingController controller;
  final String? buttonText;

  ExpenseDialogBody(
      {Key? key,
      required this.userHabit,
      this.habitProgress,
      required this.habitExpenseCategoryComboList,
      this.primaryColor,
      this.backgroundColor,
      this.title,
      required this.controller,
      this.buttonText})
      : super(key: key);

  @override
  _ExpenseDialogBodyState createState() => _ExpenseDialogBodyState();
}

class _ExpenseDialogBodyState extends State<ExpenseDialogBody> {
  HabitExpenseCategory? _selectedHabitExpenseCategory; // Local

  @override
  void initState() {
    // Initial value
    if (widget.habitProgress != null) {
      for (var el in widget.habitExpenseCategoryComboList) {
        var habitExpenseCategory = el.val as HabitExpenseCategory;
        if (habitExpenseCategory.categoryId == widget.habitProgress!.progressCatId) {
          _selectedHabitExpenseCategory = habitExpenseCategory;
          break;
        }
      }
    }

    super.initState();
  }

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
            CustomText(widget.title, fontWeight: FontWeight.w500),

            HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

            /// Amount
            CustomTextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              backgroundColor: widget.backgroundColor,
              suffixColor: widget.primaryColor,
              hintText: LocaleKeys.enterAmount,
              maxLength: 15,
              textColor: widget.primaryColor,
              inputFormatter: MoneyMaskTextInputFormatter(precision: 0, maxLength: 15),
            ),

            /// Combo
            CustomCombobox(
              margin: EdgeInsets.only(top: 15.0),
              list: widget.habitExpenseCategoryComboList,
              selectedItem: _selectedHabitExpenseCategory != null
                  ? (ComboItem()
                    ..txt = (_selectedHabitExpenseCategory?.name ?? '')
                    ..val = _selectedHabitExpenseCategory)
                  : null,
              initialText: _selectedHabitExpenseCategory != null
                  ? Func.toStr(_selectedHabitExpenseCategory!.name)
                  : LocaleKeys.selectCategory,
              primaryColor: widget.primaryColor,
              backgroundColor: widget.backgroundColor,
              onItemSelected: (ComboItem item) {
                _selectedHabitExpenseCategory = item.val;
              },
            ),

            /// Button add, edit
            CustomButton(
              style: CustomButtonStyle.Secondary,
              margin: EdgeInsets.only(top: 20.0),
              text: widget.buttonText,
              backgroundColor: widget.primaryColor,
              alignment: Alignment.center,
              onPressed: () {
                Func.hideKeyboard(context);

                // Validation
                if (Func.isEmpty(_selectedHabitExpenseCategory?.categoryId)) {
                  showCustomDialog(
                    context,
                    child: CustomDialogBody(
                      asset: Assets.warning,
                      text: LocaleKeys.pleaseSelectCategory,
                      buttonText: LocaleKeys.ok,
                    ),
                  );
                  return;
                }

                if (widget.controller.text.isNotEmpty) {
                  var amount = Func.toInt(widget.controller.text);
                  if (amount > 0) {
                    if (widget.habitProgress != null) {
                      // Edit
                      var hp = widget.habitProgress!;
                      hp.progressCatId = Func.toInt(_selectedHabitExpenseCategory?.categoryId);
                      hp.value = amount.toString();

                      BlocManager.userHabitBloc.add(UpdateHabitProgressEvent(hp));
                    } else {
                      // Add
                      var hp = HabitProgress()
                        ..progressId = 0
                        ..planId = 0
                        ..progressCatId = Func.toInt(_selectedHabitExpenseCategory?.categoryId)
                        ..answerId = 0
                        ..userHabitId = widget.userHabit.userHabitId;

                      hp.value = amount.toString();

                      BlocManager.userHabitBloc.add(AddHabitProgressEvent(hp));
                    }
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
