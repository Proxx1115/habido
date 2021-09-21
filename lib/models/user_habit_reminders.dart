class UserHabitReminders {
  int? time; // by minute

  UserHabitReminders({
    this.time,
  });

  UserHabitReminders.fromJson(dynamic json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['time'] = time;
    return map;
  }
}
