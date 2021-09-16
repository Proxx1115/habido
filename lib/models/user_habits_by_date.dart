import 'package:habido_app/models/user_habit.dart';

class UserHabitsByDate {
  String? date;
  List<UserHabit>? userHabits;

  UserHabitsByDate({this.date, this.userHabits});

  UserHabitsByDate.fromJson(dynamic json) {
    date = json['date'];
    if (json['userHabits'] != null) {
      userHabits = [];
      json['userHabits'].forEach((v) {
        userHabits?.add(UserHabit.fromJson(v));
      });
    }
    print('test');
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['date'] = date;
    if (userHabits != null) {
      map['userHabits'] = userHabits?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
