import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/user_habit_expense_category.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitTotalExpenseRoute extends StatefulWidget {
  final List<UserHabitExpenseCategory> expenseCategoryList;
  final Color primaryColor;
  final Color backgroundColor;

  const HabitTotalExpenseRoute({
    Key? key,
    required this.expenseCategoryList,
    required this.primaryColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _HabitTotalExpenseRouteState createState() => _HabitTotalExpenseRouteState();
}

class _HabitTotalExpenseRouteState extends State<HabitTotalExpenseRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.totalExpense,
      appBarLeadingColor: widget.primaryColor,
      backgroundColor: widget.backgroundColor,
      child: SingleChildScrollView(
        padding: SizeHelper.paddingScreen,
        child: Column(
          children: [
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
                              Func.toStr(widget.expenseCategoryList.length),
                              alignment: Alignment.center,
                              fontSize: 35.0,
                              fontWeight: FontWeight.w500,
                            ),

                            /// Зардал
                            CustomText(
                              LocaleKeys.expense,
                              alignment: Alignment.center,
                              fontSize: 13.0,
                              color: customColors.secondaryText,
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

  Widget _categoryChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: PieChart(
          PieChartData(
            sections: [
              for (var el in widget.expenseCategoryList) _pieChartData(el),
            ],
          ),
        ),
      ),
    );
  }

  PieChartSectionData _pieChartData(UserHabitExpenseCategory expenseCategory) {
    return PieChartSectionData(
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
          for (int i = 0; i < widget.expenseCategoryList.length; i += 2)
            _categoryChartLabelRow(
              widget.expenseCategoryList[i],
              (i + 1 < widget.expenseCategoryList.length) ? widget.expenseCategoryList[i + 1] : null,
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
                      fontSize: 13.0,
                      color: customColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
