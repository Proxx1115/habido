import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_expense_category.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/finance_statement_widget.dart';
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
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'expense_dialog_body.dart';

class HabitFinanceRoute extends StatefulWidget {
  final UserHabit userHabit;

  const HabitFinanceRoute({Key? key, required this.userHabit}) : super(key: key);

  @override
  _HabitFinanceRouteState createState() => _HabitFinanceRouteState();
}

class _HabitFinanceRouteState extends State<HabitFinanceRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late UserHabit _userHabit;

  // Total amount
  String _totalAmountTitle = LocaleKeys.total;
  double _totalAmount = 0.0;
  bool _enabledTotalAmountCard = false;

  // Graph
  List<UserHabitExpenseCategory>? _expenseCategoryList;

  // Progress
  bool _expansionTileExpanded = true;
  List<HabitProgress>? _habitProgressList;

  // Button add
  String _buttonAddText = LocaleKeys.add;

  // Add dialog
  TextEditingController _amountController = TextEditingController();
  List<ComboItem>? _expenseCategoryComboList;

  @override
  void initState() {
    _userHabit = widget.userHabit;

    BlocManager.userHabitBloc.add(GetExpenseCategoriesEvent());

    // UI
    _primaryColor = HabitHelper.getPrimaryColor(_userHabit);
    _backgroundColor = HabitHelper.getBackgroundColor(_userHabit);

    // Total amount
    if (_userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
      _enabledTotalAmountCard = false;
      _totalAmountTitle = LocaleKeys.totalSavings;
    } else if (_userHabit.habit?.goalSettings?.toolType == ToolType.Expense) {
      _enabledTotalAmountCard = true;
      _totalAmountTitle = LocaleKeys.totalExpense;
    }

    BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountEvent(_userHabit.userHabitId ?? 0));

    // Get progress
    var request = HabitProgressListByDateRequest()
      ..dateTime = Func.toDateStr(DateTime.now())
      ..userHabitId = _userHabit.userHabitId;
    BlocManager.userHabitBloc.add(GetHabitProgressListByDateEvent(request));

    // Button add
    if (_userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
      _buttonAddText = LocaleKeys.addSavings;
    } else if (_userHabit.habit?.goalSettings?.toolType == ToolType.Expense) {
      _buttonAddText = LocaleKeys.addExpense;
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: ListView(
                          children: [
                            /// Total income, expense
                            _totalAmountWidget(),

                            /// Progress list
                            _progressListWidget(),
                          ],
                        ),
                      ),
                    ),

                    /// Button add
                    _buttonAdd(),
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
    if (state is GetHabitProgressListByDateSuccess) {
      _habitProgressList = state.habitProgressList;
    } else if (state is GetHabitProgressListByDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is SaveUserHabitProgressSuccess) {
      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'habitProgressResponse': state.habitProgressResponse,
        'primaryColor': _primaryColor,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is AddHabitProgressSuccess ||
        state is UpdateHabitProgressSuccess ||
        state is DeleteHabitProgressSuccess) {
      var request = HabitProgressListByDateRequest()
        ..dateTime = Func.toDateStr(DateTime.now())
        ..userHabitId = _userHabit.userHabitId;

      BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountEvent(_userHabit.userHabitId ?? 0));
      BlocManager.userHabitBloc.add(GetHabitProgressListByDateEvent(request));
    } else if (state is SaveUserHabitProgressFailed ||
        state is AddHabitProgressFailed ||
        state is UpdateHabitProgressFailed ||
        state is DeleteHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is HabitFinanceTotalAmountSuccess) {
      _totalAmount = state.totalAmount;
      _expenseCategoryList = state.expenseCategories;

      // Total amount бүрдсэн бол дадлыг дуусгана
      if (_userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
        if (_totalAmount >= Func.toDouble(_userHabit.goalValue)) {
          SaveUserHabitProgressRequest request = SaveUserHabitProgressRequest()
            ..userHabitId = _userHabit.userHabitId
            ..value = Func.toStr(_totalAmount);
          BlocManager.userHabitBloc.add(SaveUserHabitProgressEvent(request));
        }
      }
    } else if (state is HabitFinanceTotalAmountFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is SaveUserHabitProgressSuccess) {
      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'habitProgressResponse': state.habitProgressResponse,
        'primaryColor': _primaryColor,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetExpenseCategoriesSuccess) {
      _expenseCategoryComboList = state.habitExpenseCategoryList;
    } else if (state is GetExpenseCategoriesFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _totalAmountWidget() {
    return StadiumContainer(
      onTap: () {
        if (_enabledTotalAmountCard && _expenseCategoryList != null && _expenseCategoryList!.isNotEmpty) {
          Navigator.pushNamed(context, Routes.habitTotalExpense, arguments: {
            'expenseCategoryList': _expenseCategoryList,
            'primaryColor': _primaryColor,
            'backgroundColor': _backgroundColor,
          });
        }
      },
      padding: SizeHelper.boxPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    /// Нийт
                    CustomText(_totalAmountTitle, fontSize: 13.0, color: customColors.secondaryText),

                    /// Дүн
                    CustomText(
                      Func.toMoneyStr(_totalAmount),
                      padding: EdgeInsets.only(top: 5.0),
                      color: _primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),

                    /// Indicator
                    _indicator(),
                  ],
                ),
              ),

              /// Arrow forward
              if (_enabledTotalAmountCard) SvgPicture.asset(Assets.arrow_forward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _indicator() {
    return (_userHabit.habit?.goalSettings?.toolType == ToolType.Income && Func.toDouble(_userHabit.goalValue) > 0)
        ? Container(
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: LinearPercentIndicator(
              padding: EdgeInsets.symmetric(horizontal: 0),
              lineHeight: 5,
              progressColor: _primaryColor,
              backgroundColor: customColors.greyBackground,
              percent: (_totalAmount > Func.toDouble(_userHabit.goalValue))
                  ? 1
                  : _totalAmount / Func.toDouble(_userHabit.goalValue),
            ),
          )
        : Container();
  }

  Widget _progressListWidget() {
    return (_habitProgressList != null &&
            _habitProgressList!.isNotEmpty &&
            _expenseCategoryComboList != null &&
            _expenseCategoryComboList!.isNotEmpty)
        ? FinanceStatementWidget(
            userHabit: _userHabit,
            date: DateTime.now(),
            habitProgressList: _habitProgressList!,
            primaryColor: _primaryColor,
            backgroundColor: _backgroundColor,
            expansionTileExpanded: _expansionTileExpanded,
            expenseCategoryComboList: _expenseCategoryComboList!,
            onExpansionChanged: (value) {
              setState(() {
                _expansionTileExpanded = value;
              });
            },
          )
        : Container();
  }

  Widget _buttonAdd() {
    return CustomButton(
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: _buttonAddText,
      onPressed: () {
        _amountController.clear();

        if (_userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
          // Орлого
          showCustomDialog(
            context,
            isDismissible: true,
            child: CustomDialogBody(
              child: SavingsDialogBody(
                title: _buttonAddText,
                buttonText: LocaleKeys.add,
                userHabit: _userHabit,
                primaryColor: _primaryColor,
                backgroundColor: _backgroundColor,
                controller: _amountController,
              ),
            ),
          );
        } else if (_userHabit.habit?.goalSettings?.toolType == ToolType.Expense) {
          // Зарлага
          if (_expenseCategoryComboList == null || _expenseCategoryComboList!.isNotEmpty) {
            showCustomDialog(
              context,
              isDismissible: true,
              child: CustomDialogBody(
                child: ExpenseDialogBody(
                  title: _buttonAddText,
                  buttonText: LocaleKeys.add,
                  userHabit: _userHabit,
                  habitExpenseCategoryComboList: _expenseCategoryComboList!,
                  primaryColor: _primaryColor,
                  backgroundColor: _backgroundColor,
                  controller: _amountController,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
