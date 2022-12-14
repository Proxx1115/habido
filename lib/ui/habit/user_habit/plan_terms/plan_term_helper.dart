import 'package:habido_app/models/habit_plan_terms.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/utils/localization/localization.dart';

class PlanTerm {
  static const String Daily = 'Daily';
  static const String Weekly = 'Weekly';
  static const String Monthly = 'Monthly';

  static String planTermText(String planTerm) {
    switch (planTerm) {
      case PlanTerm.Daily:
        return LocaleKeys.daily;
      case PlanTerm.Weekly:
        return LocaleKeys.weekly;
      case PlanTerm.Monthly:
        return LocaleKeys.monthly;
      default:
        return '';
    }
  }

  static List<Plan> get weeklyPlanList => List.generate(
      7,
      (index) => Plan()
        ..day = index + 1
        ..isSelected = false);

  static List<Plan> get monthlyPlanList => List.generate(
      30,
      (index) => Plan()
        ..day = index + 1
        ..isSelected = false);

  static String getWeekDayText(int day) {
    switch (day) {
      case 1:
        return LocaleKeys.mo;
      case 2:
        return LocaleKeys.tu;
      case 3:
        return LocaleKeys.we;
      case 4:
        return LocaleKeys.th;
      case 5:
        return LocaleKeys.fr;
      case 6:
        return LocaleKeys.sa;
      case 7:
        return LocaleKeys.su;
      default:
        return '';
    }
  }

  static String getInitialPlanTerm(HabitPlanTerms? habitPlanTerms) {
    var res = PlanTerm.Daily;
    if (habitPlanTerms != null) {
      if (habitPlanTerms.daily ?? false) {
        res = PlanTerm.Daily;
      } else if (habitPlanTerms.weekly ?? false) {
        res = PlanTerm.Weekly;
      } else if (habitPlanTerms.monthly ?? false) {
        res = PlanTerm.Monthly;
      }
    }

    return res;
  }
}
