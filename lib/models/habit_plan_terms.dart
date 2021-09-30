class HabitPlanTerms {
  HabitPlanTerms({
    this.termId,
    this.daily,
    this.weekly,
    this.monthly,
  });

  HabitPlanTerms.fromJson(dynamic json) {
    termId = json['termId'];
    daily = json['daily'];
    weekly = json['weekly'];
    monthly = json['monthly'];
  }

  int? termId;
  bool? daily;
  bool? weekly;
  bool? monthly;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['termId'] = termId;
    map['daily'] = daily;
    map['weekly'] = weekly;
    map['monthly'] = monthly;
    return map;
  }
}
