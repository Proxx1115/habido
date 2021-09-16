import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_expense_category.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/expandable_card.dart';
import 'package:habido_app/ui/habit/progress/habit_finance/expandable_card_list_item.dart';
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
  List<UserHabitExpenseCategory>? _expenseCategories;

  // Progress
  List<HabitProgress>? _habitProgressList;

  // Button add
  String _buttonAddText = LocaleKeys.add;

  // Add dialog
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    _userHabit = widget.userHabit;

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
      ..userHabitId = widget.userHabit.userHabitId;
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
                    /// Total income, expense
                    _totalAmountWidget(),

                    /// Progress list
                    Expanded(
                      child: _progressListWidget(),
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
    if (state is GetHabitProgressListByDateSuccess) {
      _habitProgressList = state.habitProgressList;
    } else if (state is GetHabitProgressListByDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is SaveUserHabitProgressSuccess) {
      BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

      Navigator.pushReplacementNamed(context, Routes.habitSuccess, arguments: {
        'title': LocaleKeys.youDidIt,
        'primaryColor': _primaryColor,
      });
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is AddHabitProgressSuccess) {
      var request = HabitProgressListByDateRequest()
        ..dateTime = Func.toDateStr(DateTime.now())
        ..userHabitId = widget.userHabit.userHabitId;

      BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountEvent(_userHabit.userHabitId ?? 0));
      BlocManager.userHabitBloc.add(GetHabitProgressListByDateEvent(request));
    } else if (state is SaveUserHabitProgressFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is HabitFinanceTotalAmountSuccess) {
      _totalAmount = state.totalAmount;
      _expenseCategories = state.expenseCategories;
    } else if (state is HabitFinanceTotalAmountFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _totalAmountWidget() {
    return StadiumContainer(
      onTap: () {
        if (_enabledTotalAmountCard) {
          Navigator.pushNamed(context, Routes.habitFinanceStmt, arguments: {
            'userHabit': _userHabit,
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
                  ],
                ),
              ),

              /// Arrow forward
              if (_enabledTotalAmountCard) SvgPicture.asset(Assets.arrow_forward),
            ],
          ),

          /// Progress bar
          Container(
            padding: EdgeInsets.only(top: 15.0),
          )
        ],
      ),
    );
  }

  Widget _progressListWidget() {
    return (_habitProgressList != null && _habitProgressList!.isNotEmpty)
        ? ExpandableCard(
            title: Func.toDateStr(DateTime.now()),
            expandableCardListItems: [
              for (var el in _habitProgressList!) ExpandableCardListItem(text: el.value ?? ''),
            ],
          )
        : Container();
  }

  Widget _buttonFinish() {
    return CustomButton(
      margin: EdgeInsets.only(top: 15.0),
      alignment: Alignment.bottomRight,
      style: CustomButtonStyle.Secondary,
      backgroundColor: _primaryColor,
      text: _buttonAddText,
      onPressed: () {
        _amountController.clear();

        if (_userHabit.habit?.goalSettings?.toolType == ToolType.Income) {
          showCustomDialog(
            context,
            isDismissible: true,
            child: CustomDialogBody(
              child: _addSavingsDialogBody(),
            ),
          );
        } else if (_userHabit.habit?.goalSettings?.toolType == ToolType.Expense) {
          //
        }
      },
    );
  }

  Widget _addSavingsDialogBody() {
    return GestureDetector(
      onTap: () {
        Func.hideKeyboard(context);
      },
      child: Container(
        child: Column(
          children: [
            /// Title
            CustomText(_buttonAddText, fontWeight: FontWeight.w500),

            HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

            /// Amount
            CustomTextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              backgroundColor: _backgroundColor,
              hintText: LocaleKeys.enterAmount,
              maxLength: 15,
            ),

            /// Button add
            CustomButton(
              style: CustomButtonStyle.Secondary,
              margin: EdgeInsets.only(top: 20.0),
              text: _buttonAddText,
              backgroundColor: _primaryColor,
              alignment: Alignment.center,
              onPressed: () {
                Func.hideKeyboard(context);

                if (_amountController.text.isNotEmpty) {
                  var habitProgress = HabitProgress()
                    ..progressId = 0
                    ..planId = 0
                    ..value = _amountController.text
                    // ..note = ''
                    // ..photo = ''
                    ..progressCatId = 0
                    ..answerId = 0
                    ..userHabitId = _userHabit.userHabitId;

                  BlocManager.userHabitBloc.add(AddHabitProgressEvent(habitProgress));
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
