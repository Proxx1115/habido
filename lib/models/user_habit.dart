import 'package:habido_app/models/base_response.dart';

import 'user_habit_reminders.dart';
import 'plan.dart';

class UserHabit extends BaseResponse {
  int? userHabitId;
  int? userId;
  int? habitId;
  String? name;
  String? startDate;
  String? endDate;
  bool? isReminder;
  String? repeatName;
  bool? hasGoal;
  String? goalValue;
  String? note;
  String? userNote;
  String? status;
  List<UserHabitReminders>? userHabitReminders;
  List<Plan>? plans;

  UserHabit({
    this.userHabitId,
    this.userId,
    this.habitId,
    this.name,
    this.startDate,
    this.endDate,
    this.isReminder,
    this.repeatName,
    this.hasGoal,
    this.goalValue,
    this.note,
    this.userNote,
    this.status,
    this.userHabitReminders,
    this.plans,
  });

  UserHabit.fromJson(dynamic json) {
    parseBaseParams(json);
    userHabitId = json['userHabitId'];
    userId = json['userId'];
    habitId = json['habitId'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isReminder = json['isReminder'];
    repeatName = json['repeatName'];
    hasGoal = json['hasGoal'];
    goalValue = json['goalValue'];
    note = json['note'];
    userNote = json['userNote'];
    status = json['status'];
    if (json['userHabitReminders'] != null) {
      userHabitReminders = [];
      json['userHabitReminders'].forEach((v) {
        userHabitReminders?.add(UserHabitReminders.fromJson(v));
      });
    }
    if (json['plans'] != null) {
      plans = [];
      json['plans'].forEach((v) {
        plans?.add(Plan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['userId'] = userId;
    map['habitId'] = habitId;
    map['name'] = name;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['isReminder'] = isReminder;
    map['repeatName'] = repeatName;
    map['hasGoal'] = hasGoal;
    map['goalValue'] = goalValue;
    map['note'] = note;
    map['userNote'] = userNote;
    map['status'] = status;
    if (userHabitReminders != null) {
      map['userHabitReminders'] = userHabitReminders?.map((v) => v.toJson()).toList();
    }
    if (plans != null) {
      map['plans'] = plans?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
