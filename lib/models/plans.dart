class Plans {
  String? weekDay;
  String? planDate;

  Plans({this.weekDay, this.planDate});

  Plans.fromJson(dynamic json) {
    weekDay = json['weekDay'];
    planDate = json['planDate'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['weekDay'] = weekDay;
    map['planDate'] = planDate;
    return map;
  }
}

class PlanTerm {
  static const String Daily = 'Daily';
  static const String Weekly = 'Weekly';
  static const String Monthly = 'Monthly';
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
