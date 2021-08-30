import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/ui/habit/habit/plan_terms/plan_terms_bloc.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class PlanTermsWidget extends StatefulWidget {
  final Color primaryColor;
  final Function(List<Plan>) callBack;

  const PlanTermsWidget({
    Key? key,
    required this.primaryColor,
    required this.callBack,
  }) : super(key: key);

  @override
  _PlanTermsWidgetState createState() => _PlanTermsWidgetState();
}

class _PlanTermsWidgetState extends State<PlanTermsWidget> {
  // UI
  late PlanTermsBloc _planTermsBloc;

  // Data
  var _weeklyPlanList = PlanTerm.weeklyPlanList;
  var _monthlyPlanList = <Plan>[];

  // Tab bar
  String _selectedPlanTerm = PlanTerm.Daily;

  @override
  void initState() {
    _planTermsBloc = PlanTermsBloc();
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
        child: BlocBuilder<PlanTermsBloc, PlanTermsState>(builder: (context, state) {
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
      _selectedPlanTerm = state.planTerm;
    } else if (state is WeekDaySelectionChangedState) {
      _weeklyPlanList[state.index].isSelected = state.isSelected;
      widget.callBack(_weeklyPlanList);
    }
  }

  Widget _tabBar() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: SizeHelper.borderRadiusOdd,
        color: customColors.secondaryBackground,
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
          _planTermsBloc.add(ChangePlanTermEvent(planTerm));
        },
        borderRadius: SizeHelper.borderRadiusOdd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: SizeHelper.borderRadiusOdd,
            color: _selectedPlanTerm == planTerm ? widget.primaryColor : customColors.secondaryBackground,
          ),
          child: CustomText(
            PlanTerm.planTermText(planTerm),
            alignment: Alignment.center,
            fontWeight: FontWeight.w500,
            color: _selectedPlanTerm == planTerm ? customColors.whiteText : customColors.secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_selectedPlanTerm == PlanTerm.Weekly) {
      return Container(
        margin: EdgeInsets.only(top: 15.0),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 15.0),
        height: 80.0,
        decoration: BoxDecoration(borderRadius: SizeHelper.borderRadiusOdd, color: customColors.secondaryBackground),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_weeklyPlanList.length, (index) => _weekDayItem(index))

            // [
            //   for (var el in _weeklyPlanList) _weekDayItem(el),
            // ],
            ),
      );
    } else if (_selectedPlanTerm == PlanTerm.Monthly) {
      return Container();
    } else {
      return Container();
    }
  }

  Widget _weekDayItem(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _planTermsBloc.add(
            ChangeWeekDaySelectionEvent(index, !(_weeklyPlanList[index].isSelected ?? false)),
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
                : Border.all(width: SizeHelper.borderWidth, color: customColors.primaryBorder),
            color: (_weeklyPlanList[index].isSelected ?? false) ? widget.primaryColor : customColors.secondaryBackground,
          ),
          child: CustomText(
            _weeklyPlanList[index].weekDayText,
            alignment: Alignment.center,
            color: (_weeklyPlanList[index].isSelected ?? false) ? customColors.whiteText : customColors.secondaryText,
          ),
        ),
      ),
    );
  }

// Plans()
//   ..weekDay = WeekDays.Fri
//   ..term = PlanTerm.Week,
}
