import 'package:habido_app/utils/localization/localization.dart';

class Plan {
  int? day;
  bool? isSelected; // Local param

  Plan({this.day});

  Plan.fromJson(dynamic json) {
    day = json['day'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['day'] = day;
    map['isSelected'] = isSelected;
    return map;
  }
}

class PlanTerm {
  static const String Daily = 'Daily';
  static const String Weekly = 'Weekly';
  static const String Monthly = 'Monthly';

  static String planTermText(String planTerm) {
    switch (planTerm) {
      case PlanTerm.Daily:
        return LocaleKeys.daily;
      case PlanTerm.Weekly:
        return LocaleKeys.week;
      case PlanTerm.Monthly:
        return LocaleKeys.monthly;
      default:
        return '';
    }
  }

  static List<Plan> get weeklyPlanList => List.generate(
      7,
      (index) => Plan()
        ..day = index
        ..isSelected = false);

  static List<Plan> get monthlyPlanList => List.generate(
      30,
      (index) => Plan()
        ..day = index
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
}
