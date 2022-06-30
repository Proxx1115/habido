import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_plan_terms.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';
import 'plan_term_helper.dart';
import 'plan_terms_bloc.dart';

class PlanTermsWidget extends StatefulWidget {
  final Color primaryColor;

  // Plan term
  final HabitPlanTerms? habitPlanTerms;
  final String? initialPlanTerm;
  final Function(String) onPlanTermChanged;

  // Plan list
  final List<Plan>? planList;
  final Function(List<Plan>) onPlanListChanged;

  const PlanTermsWidget({
    Key? key,
    required this.primaryColor,
    this.habitPlanTerms,
    required this.initialPlanTerm,
    required this.onPlanTermChanged,
    required this.planList,
    required this.onPlanListChanged,
  }) : super(key: key);

  @override
  _PlanTermsWidgetState createState() => _PlanTermsWidgetState();
}

class _PlanTermsWidgetState extends State<PlanTermsWidget> {
  // UI
  late PlanTermsBloc _planTermsBloc;

  // Data
  List<Plan> _weeklyPlanList = PlanTerm.weeklyPlanList;
  List<Plan> _monthlyPlanList = PlanTerm.monthlyPlanList;

  // Tab bar
  late String _selectedPlanTerm;

  @override
  void initState() {
    _planTermsBloc = PlanTermsBloc();

    _selectedPlanTerm = widget.initialPlanTerm ?? PlanTerm.Daily;

    // Plan list
    for (var el in widget.planList ?? []) {
      if (el.day != null) {
        if (_selectedPlanTerm == PlanTerm.Weekly) {
          _weeklyPlanList[el.day! - 1].isSelected = true;
        } else {
          _monthlyPlanList[el.day! - 1].isSelected = true;
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _planTermsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _planTermsBloc,
      child: BlocListener<PlanTermsBloc, PlanTermsState>(
        listener: _blocListener,
        child: BlocBuilder<PlanTermsBloc, PlanTermsState>(
            builder: (context, state) {
          return Column(
            children: [
              /// Tab bar
              _tabBar(),

              /// Body
              _body(),
            ],
          );
        }),
      ),
    );
  }

  void _blocListener(BuildContext context, PlanTermsState state) {
    if (state is PlanTermChangedState) {
      // Change tab
      print(_selectedPlanTerm);
      _selectedPlanTerm = state.planTerm;
      widget.onPlanTermChanged(_selectedPlanTerm);

      // Callback
      if (_selectedPlanTerm == PlanTerm.Weekly) {
        widget.onPlanListChanged(_weeklyPlanList);
      } else if (_selectedPlanTerm == PlanTerm.Monthly) {
        widget.onPlanListChanged(_monthlyPlanList);
      }
    } else if (state is WeekDaySelectionChangedState) {
      print('${_weeklyPlanList[state.index].day}: ${state.isSelected}');
      _weeklyPlanList[state.index].isSelected = state.isSelected;
      widget.onPlanListChanged(_weeklyPlanList);
    } else if (state is MonthDaySelectionChangedState) {
      print('${_monthlyPlanList[state.index].day}: ${state.isSelected}');
      _monthlyPlanList[state.index].isSelected = state.isSelected;
      widget.onPlanListChanged(_monthlyPlanList);
    }
  }

  Widget _tabBar() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: SizeHelper.borderRadiusOdd,
        color: customColors.whiteBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _planTermItem(PlanTerm.Daily),
          _planTermItem(PlanTerm.Weekly),
          _planTermItem(PlanTerm.Monthly),
        ],
      ),
    );
  }

  Widget _planTermItem(String planTerm) {
    return Expanded(
      child: InkWell(
        onTap: () {
          bool isEnabled = false;
          if (widget.habitPlanTerms == null) {
            isEnabled = true;
          } else {
            switch (planTerm) {
              case PlanTerm.Daily:
                isEnabled = widget.habitPlanTerms!.daily ?? false;
                break;
              case PlanTerm.Weekly:
                isEnabled = widget.habitPlanTerms!.weekly ?? false;
                break;
              case PlanTerm.Monthly:
                isEnabled = widget.habitPlanTerms!.monthly ?? false;
                break;
            }
          }

          if (isEnabled) _planTermsBloc.add(ChangePlanTermEvent(planTerm));
        },
        borderRadius: SizeHelper.borderRadiusOdd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: SizeHelper.borderRadiusOdd,
            color: _selectedPlanTerm == planTerm
                ? widget.primaryColor
                : customColors.whiteBackground,
          ),
          child: CustomText(
            PlanTerm.planTermText(planTerm),
            alignment: Alignment.center,
            fontWeight: FontWeight.w500,
            // color: _selectedPlanTerm == planTerm
            //     ? customColors.whiteText
            //     : customColors.greyText,
            color: ConstantColors.grey,
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_selectedPlanTerm == PlanTerm.Weekly) {
      return _weekDaysWidget();
    } else if (_selectedPlanTerm == PlanTerm.Monthly) {
      return _monthDaysWidget();
    } else {
      return Container();
    }
  }

  Widget _weekDaysWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 15.0),
      decoration: BoxDecoration(
          borderRadius: SizeHelper.borderRadiusOdd,
          color: customColors.whiteBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            _weeklyPlanList.length, (index) => _weekDayItem(index)),
      ),
    );
  }

  Widget _weekDayItem(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _planTermsBloc.add(
            ChangeWeekDaySelectionEvent(
                index, !(_weeklyPlanList[index].isSelected ?? false)),
          );
        },
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          height: 50.0,
          margin: EdgeInsets.only(right: 7.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: (_weeklyPlanList[index].isSelected ?? false)
                ? null
                : Border.all(
                    width: SizeHelper.borderWidth,
                    color: customColors.primaryBorder),
            color: (_weeklyPlanList[index].isSelected ?? false)
                ? widget.primaryColor
                : customColors.whiteBackground,
          ),
          child: CustomText(
            PlanTerm.getWeekDayText(_weeklyPlanList[index].day ?? 0),
            alignment: Alignment.center,
            color: (_weeklyPlanList[index].isSelected ?? false)
                ? customColors.whiteText
                : customColors.greyText,
          ),
        ),
      ),
    );
  }

  Widget _monthDaysWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 15.0),
      decoration: BoxDecoration(
          borderRadius: SizeHelper.borderRadiusOdd,
          color: customColors.whiteBackground),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 6; i++) Expanded(child: _monthDayItem(i)),
            ],
          ),
          SizedBox(height: 7.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 6; i < 12; i++) Expanded(child: _monthDayItem(i)),
            ],
          ),
          SizedBox(height: 7.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 12; i < 18; i++) Expanded(child: _monthDayItem(i)),
            ],
          ),
          SizedBox(height: 7.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 18; i < 24; i++) Expanded(child: _monthDayItem(i)),
            ],
          ),
          SizedBox(height: 7.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 24; i < 30; i++) Expanded(child: _monthDayItem(i)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthDayItem(int index) {
    return InkWell(
      onTap: () {
        _planTermsBloc.add(
          ChangeMonthDaySelectionEvent(
              index, !(_monthlyPlanList[index].isSelected ?? false)),
        );
      },
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        height: 50.0,
        margin: EdgeInsets.only(right: 7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: (_monthlyPlanList[index].isSelected ?? false)
              ? null
              : Border.all(
                  width: SizeHelper.borderWidth,
                  color: customColors.primaryBorder),
          color: (_monthlyPlanList[index].isSelected ?? false)
              ? widget.primaryColor
              : customColors.whiteBackground,
        ),
        child: CustomText(
          Func.toStr(_monthlyPlanList[index].day ?? 0),
          alignment: Alignment.center,
          color: (_monthlyPlanList[index].isSelected ?? false)
              ? customColors.whiteText
              : customColors.greyText,
        ),
      ),
    );
  }
}
