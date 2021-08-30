import 'package:habido_app/utils/localization/localization.dart';

class Plan {
  String? weekDay;
  String? planDate;

  String? weekDayText; // Local param
  bool? isSelected; // Local param

  Plan({this.weekDay, this.planDate});

  Plan.fromJson(dynamic json) {
    weekDay = json['weekDay'];
    planDate = json['planDate'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['weekDay'] = weekDay;
    map['planDate'] = planDate;
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

  static List<Plan> get weeklyPlanList => [
        Plan()
          ..weekDay = WeekDays.Mon
          ..weekDayText = LocaleKeys.mo
          ..isSelected = false,
        Plan()
          ..weekDay = WeekDays.Tue
          ..weekDayText = LocaleKeys.tu
          ..isSelected = false,
        Plan()
          ..weekDay = WeekDays.Wed
          ..weekDayText = LocaleKeys.we
          ..isSelected = false,
        Plan()
          ..weekDay = WeekDays.Thu
          ..weekDayText = LocaleKeys.th
          ..isSelected = false,
        Plan()
          ..weekDay = WeekDays.Fri
          ..weekDayText = LocaleKeys.fr
          ..isSelected = false,
        Plan()
          ..weekDay = WeekDays.Sat
          ..weekDayText = LocaleKeys.sa
          ..isSelected = false,
        Plan()
          ..weekDay = WeekDays.Sun
          ..weekDayText = LocaleKeys.su
          ..isSelected = false,
      ];
}

class WeekDays {
  static const String Mon = 'Mon';
  static const String Tue = 'Tue';
  static const String Wed = 'Wed';
  static const String Thu = 'Thu';
  static const String Fri = 'Fri';
  static const String Sat = 'Sat';
  static const String Sun = 'Sun';
}
