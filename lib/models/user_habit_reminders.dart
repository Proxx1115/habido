class UserHabitReminders {
  // int? reminderId;
  // int? userHabitId;
  int? time;

  UserHabitReminders({
    // this.reminderId,
    // this.userHabitId,
    this.time,
  });

  UserHabitReminders.fromJson(dynamic json) {
    // reminderId = json['reminderId'];
    // userHabitId = json['userHabitId'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    // map['reminderId'] = reminderId;
    // map['userHabitId'] = userHabitId;
    map['time'] = time;
    return map;
  }
}
