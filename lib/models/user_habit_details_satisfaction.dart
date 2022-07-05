class UserHabitDetailsSatisfaction {
  String? date;
  int? value;

  UserHabitDetailsSatisfaction({
    this.date,
    this.value,
  });

  UserHabitDetailsSatisfaction.fromJson(dynamic json) {
    date = json['date'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['value'] = value;
    return map;
  }
}
