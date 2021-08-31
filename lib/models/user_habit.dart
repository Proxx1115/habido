import 'package:habido_app/models/base_response.dart';
import 'habit.dart';
import 'user_habit_reminders.dart';
import 'plan.dart';

class UserHabit extends BaseResponse {
  int? userHabitId;
  String? name;
  String? startDate;
  String? endDate;
  String? userNote; // Өөрийн тэмдэглэл

  // HabitGoalSettings
  String? planTerm; // PlanTerm: Daily, Weekly, Monthly
  String? goalValue; // Min max

  // Habit settings
  int? habitId;
  Habit? habit;

  List<UserHabitReminders>? userHabitReminders;
  List<Plan>? plans;

  UserHabit({
    this.userHabitId,
    this.name,
    this.startDate,
    this.endDate,
    this.userNote,
    this.planTerm,
    this.goalValue,
    this.habitId,
    this.habit,
    this.userHabitReminders,
    this.plans,
  });

  UserHabit.fromJson(dynamic json) {
    parseBaseParams(json);
    userHabitId = json['userHabitId'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    userNote = json['userNote'];
    planTerm = json['planTerm'];
    goalValue = json['goalValue'];
    habitId = json['habitId'];
    habit = json['habit'] != null ? Habit.fromJson(json['habit']) : null;
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
    map['habitId'] = habitId;
    map['name'] = name;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['planTerm'] = planTerm;
    map['goalValue'] = goalValue;
    map['userNote'] = userNote;
    if (userHabitReminders != null) {
      map['userHabitReminders'] = userHabitReminders?.map((v) => v.toJson()).toList();
    }
    if (plans != null) {
      map['plans'] = plans?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
