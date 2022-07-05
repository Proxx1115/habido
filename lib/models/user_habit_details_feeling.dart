class UserHabitDetailsFeeling {
  int? planId;
  String? date;
  int? value;
  String? photo;
  String? note;

  UserHabitDetailsFeeling({
    this.planId,
    this.date,
    this.value,
    this.photo,
    this.note,
  });

  UserHabitDetailsFeeling.fromJson(dynamic json) {
    planId = json['planId'];
    date = json['date'];
    value = json['value'];
    photo = json['photo'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planId'] = planId;
    map['date'] = date;
    map['value'] = value;
    map['photo'] = photo;
    map['note'] = note;
    return map;
  }
}
