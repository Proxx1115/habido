import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/expense_dialog_body.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/savings_dialog_body.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/combobox/combo_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class FinanceStatementWidget extends StatelessWidget {
  final UserHabit userHabit;
  final List<HabitProgress> habitProgressList;
  final List<ComboItem> expenseCategoryComboList;
  final Color? primaryColor;
  final Color? backgroundColor;
  final bool expansionTileExpanded;
  final Function(bool)? onExpansionChanged;
  final bool enabledButtons;

  final SlidableController _controller = SlidableController();
  final TextEditingController _amountController = TextEditingController();

  FinanceStatementWidget({
    Key? key,
    required this.userHabit,
    required this.habitProgressList,
    required this.expenseCategoryComboList,
    this.primaryColor,
    this.backgroundColor,
    required this.expansionTileExpanded,
    this.onExpansionChanged,
    this.enabledButtons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
          child: ExpansionTile(
            collapsedBackgroundColor: customColors.secondaryBackground,
            backgroundColor: customColors.secondaryBackground,
            initiallyExpanded: expansionTileExpanded,

            /// Title
            title: CustomText(
              Func.toWeekDay(DateTime.now()) +
                  ' ${LocaleKeys.day2}, ${Func.toDateStr(DateTime.now(), dateFormat: 'yyyy.MM.dd')}',
              fontWeight: FontWeight.w500,
            ),

            /// Icon
            trailing: Container(
              height: 24.0,
              width: 24.0,
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor ?? customColors.primary),
              child: SvgPicture.asset(expansionTileExpanded ? Assets.minus12 : Assets.plus12),
            ),

            /// Progress list
            children: <Widget>[
              for (var el in habitProgressList)
                Container(
                  height: SizeHelper.listItemHeight,
                  child: Column(
                    children: [
                      /// Line
                      Container(padding: SizeHelper.boxPaddingHorizontal, child: HorizontalLine()),

                      /// Slidable item
                      Slidable(
                        controller: _controller,
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.15,
                        child: Container(
                          padding: SizeHelper.boxPaddingHorizontal,
                          height: SizeHelper.listItemHeight - 2,
                          child: Row(
                            children: [
                              /// Category name
                              if (Func.isNotEmpty(el.progressCatName))
                                Expanded(
                                  child: CustomText(el.progressCatName),
                                ),

                              CustomText(
                                Func.toMoneyStr(el.value ?? ''),
                                color: primaryColor ?? customColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        secondaryActions: <Widget>[
                          /// Button edit
                          if (enabledButtons) _buttonEdit(context, el),

                          /// Button delete
                          if (enabledButtons) _buttonDelete(context, el),
                        ],
                      ),
                    ],
                  ),
                ),

              /// Button - Дэлгэрэнгүй
              CustomButton(
                text: LocaleKeys.detail,
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, SizeHelper.margin),
                style: CustomButtonStyle.Mini,
                alignment: Alignment.center,
                backgroundColor: primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.habitFinanceStmt, arguments: {
                    'userHabit': userHabit,
                  });
                },
              ),

              // ListTile(title: Text('This is tile number 2')),
            ],
            onExpansionChanged: (bool expanded) {
              if (onExpansionChanged != null) onExpansionChanged!(expanded);
            },
          ),
        ),
      ),
    );
  }

  Widget _buttonEdit(BuildContext context, HabitProgress habitProgress) {
    return IconSlideAction(
      color: Colors.transparent,
      iconWidget: ButtonStadium(
        asset: Assets.edit,
        size: SizeHelper.listItemHeight,
        borderRadius: 0.0,
        backgroundColor: customColors.yellowBackground,
        iconColor: customColors.iconWhite,
        enabled: false,
      ),
      onTap: () {
        _amountController.text = habitProgress.value ?? '';

        if (userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
          showCustomDialog(
            context,
            isDismissible: true,
            child: CustomDialogBody(
              child: SavingsDialogBody(
                title: LocaleKeys.editSavings,
                buttonText: LocaleKeys.edit2,
                userHabit: userHabit,
                habitProgress: habitProgress,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
                controller: _amountController,
              ),
            ),
          );
        } else if (userHabit.habit?.goalSettings?.toolType == ToolType.Expense) {
          showCustomDialog(
            context,
            isDismissible: true,
            child: CustomDialogBody(
              child: ExpenseDialogBody(
                title: LocaleKeys.editExpense,
                buttonText: LocaleKeys.edit2,
                userHabit: userHabit,
                habitProgress: habitProgress,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
                controller: _amountController,
                habitExpenseCategoryComboList: expenseCategoryComboList,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buttonDelete(BuildContext context, HabitProgress habitProgress) {
    return IconSlideAction(
      color: Colors.transparent,
      iconWidget: ButtonStadium(
        asset: Assets.trash,
        borderRadius: 0.0,
        size: SizeHelper.listItemHeight,
        backgroundColor: customColors.pinkBackground,
        iconColor: customColors.iconWhite,
        enabled: false,
      ),
      onTap: () {
        showCustomDialog(
          context,
          child: CustomDialogBody(
            asset: Assets.warning,
            text: LocaleKeys.sureToDelete,
            buttonText: LocaleKeys.yes,
            onPressedButton: () {
              BlocManager.userHabitBloc.add(DeleteHabitProgressEvent(habitProgress.progressId ?? 0));
            },
            button2Text: LocaleKeys.no,
          ),
        );
      },
    );
  }
}
