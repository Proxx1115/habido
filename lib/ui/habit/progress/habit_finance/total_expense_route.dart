import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/habit_total_amount_by_date_request.dart';
import 'package:habido_app/models/user_habit_expense_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitTotalExpenseRoute extends StatefulWidget {
  final int userHabitId;

  const HabitTotalExpenseRoute({
    Key? key,
    required this.userHabitId,
  }) : super(key: key);

  @override
  _HabitTotalExpenseRouteState createState() => _HabitTotalExpenseRouteState();
}

class _HabitTotalExpenseRouteState extends State<HabitTotalExpenseRoute> {
  List<UserHabitExpenseCategory> _expenseCategoryList = [];
  String? _selectedDateInterval;
  List _dateFilters = ["Бүгд", "Сүүлийн 7 хоног", "Сүүлийн 1 сар"];

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountEvent(widget.userHabitId));
    _selectedDateInterval = _dateFilters[0];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.userHabitBloc,
        child: BlocListener<UserHabitBloc, UserHabitState>(
          listener: _blocListener,
          child: BlocBuilder<UserHabitBloc, UserHabitState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  _blocListener(BuildContext context, UserHabitState state) {
    if (state is HabitFinanceTotalAmountSuccess) {
      _expenseCategoryList = state.expenseCategories;
      print("seks BUGD");
    } else if (state is HabitFinanceTotalAmountFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is HabitFinanceTotalAmountByDateSuccess) {
      print("seks By Date");
      _expenseCategoryList = state.expenseCategories;
    } else if (state is HabitFinanceTotalAmountByDateFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.totalExpense,
      child: SingleChildScrollView(
        padding: SizeHelper.screenPadding,
        child: Column(
          children: [
            /// Filter tabs
            _tabItem(),

            StadiumContainer(
              margin: EdgeInsets.only(top: 15.0),
              padding: EdgeInsets.fromLTRB(15.0, SizeHelper.margin, 15.0, SizeHelper.margin),
              borderRadius: SizeHelper.borderRadiusOdd,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Chart
                      _categoryChart(),

                      Center(
                        child: Column(
                          children: [
                            /// Category count
                            CustomText(
                              Func.toStr(_expenseCategoryList.length),
                              alignment: Alignment.center,
                              fontSize: 35.0,
                              fontWeight: FontWeight.w500,
                            ),

                            /// Зардал
                            CustomText(
                              LocaleKeys.expense,
                              alignment: Alignment.center,
                              fontSize: 13.0,
                              color: customColors.greyText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Labels
                  _categoryChartLabels(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (String el in _dateFilters) _tabButtonItem(el),
        ],
      ),
    );
  }

  Widget _tabButtonItem(String text) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _selectedDateInterval = text;
          _onFilterByDate();
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(15), color: _selectedDateInterval == text ? customColors.primary : Colors.white),
          child: IntrinsicWidth(
            child: CustomText(
              text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _selectedDateInterval == text ? Colors.white : customColors.primaryText,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: PieChart(
          PieChartData(
            sections: [
              for (var el in _expenseCategoryList) _pieChartData(el),
            ],
          ),
        ),
      ),
    );
  }

  PieChartSectionData _pieChartData(UserHabitExpenseCategory expenseCategory) {
    return PieChartSectionData(
      radius: 24,
      color: HexColor.fromHex(expenseCategory.categoryColor ?? '#A9B0BB'),
      value: Func.toDouble(expenseCategory.habitCatPercentage),
      title: '${Func.toInt(expenseCategory.habitCatPercentage)}%',
      titleStyle: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _categoryChartLabels() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          for (int i = 0; i < _expenseCategoryList.length; i += 2)
            _categoryChartLabelRow(
              _expenseCategoryList[i],
              (i + 1 < _expenseCategoryList.length) ? _expenseCategoryList[i + 1] : null,
            ),
        ],
      ),
    );
  }

  Widget _categoryChartLabelRow(
    UserHabitExpenseCategory expenseCategory1,
    UserHabitExpenseCategory? expenseCategory2,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _categoryChartLabelItem(expenseCategory1),
          SizedBox(width: 15.0),
          _categoryChartLabelItem(expenseCategory2),
        ],
      ),
    );
  }

  Widget _categoryChartLabelItem(UserHabitExpenseCategory? expenseCategory) {
    return Expanded(
      child: expenseCategory != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: customColors.primaryBackground,
              ),
              child: Row(
                children: [
                  /// Dot
                  Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: HexColor.fromHex(expenseCategory.categoryColor ?? '#fa6c51'),
                    ),
                  ),

                  SizedBox(width: 10.0),

                  /// Text
                  Expanded(
                    child: CustomText(
                      expenseCategory.expenseCatName,
                      maxLines: 3,
                      fontSize: 13.0,
                      color: customColors.greyText,
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  _onFilterByDate() {
    if (_selectedDateInterval == _dateFilters[0]) {
      BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountEvent(widget.userHabitId));
    } else if (_selectedDateInterval == _dateFilters[1]) {
      var request = HabitTotalAmountByDateRequest()
        ..startDate = Func.toDateStr(DateTime.now().subtract(Duration(days: 7)))
        ..lastDate = Func.toDateStr(DateTime.now())
        ..userHabitId = widget.userHabitId;
      BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountByDateEvent(request));
    } else if (_selectedDateInterval == _dateFilters[2]) {
      var request = HabitTotalAmountByDateRequest()
        ..startDate = Func.toDateStr(DateTime.now().subtract(Duration(days: 30)))
        ..lastDate = Func.toDateStr(DateTime.now())
        ..userHabitId = widget.userHabitId;
      BlocManager.userHabitBloc.add(GetHabitFinanceTotalAmountByDateEvent(request));
    }
  }
}
