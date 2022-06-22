class ActiveHabit {
  int? userHabitId;
  int? habitId;
  String? name;
  String? photo;
  String? color;
  String? backgroundColor;
  String? planTerm;
  String? plans;
  String? goalType;
  String? goalValue;
  String? startDate;
  String? endDate;

  ActiveHabit({
    this.userHabitId,
    this.habitId,
    this.name,
    this.photo,
    this.color,
    this.backgroundColor,
    this.planTerm,
    this.plans,
    this.goalType,
    this.goalValue,
    this.startDate,
    this.endDate,
  });

  ActiveHabit.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    habitId = json['habitId'];
    name = json['name'];
    photo = json['photo'];
    color = json['color'];
    backgroundColor = json['backgroundColor'];
    planTerm = json['planTerm'];
    plans = json['plans'];
    goalType = json['goalType'];
    goalValue = json['goalValue'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['habitId'] = habitId;
    map['name'] = name;
    map['photo'] = photo;
    map['color'] = color;
    map['backgroundColor'] = backgroundColor;
    map['planTerm'] = planTerm;
    map['plans'] = plans;
    map['goalType'] = goalType;
    map['goalValue'] = goalValue;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    return map;
  }
}
