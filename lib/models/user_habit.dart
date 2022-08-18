import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/utils/func.dart';
import 'habit.dart';
import 'user_habit_reminders.dart';
import 'plan.dart';

class UserHabit extends BaseResponse {
  int? userHabitId;
  String? name;
  String? startDate;
  String? endDate;
  String? reminderMessage; // Өөртөө сануулах гарчиг
  String? userNote; // Өөрийн тэмдэглэл
  bool? isDone;
  String? habitState;
  double? percentage;

  // HabitGoalSettings
  String? planDate;
  String? planTerm; // PlanTerm: Daily, Weekly, Monthly
  String? goalValue; // Min max
  String? currentValue; // Local param (Drink water)

  // Habit settings
  int? habitId;

  bool? isDynamicHabit;
  Habit? habit;

  List<UserHabitReminders>? userHabitReminders;
  List<Plan>? planDays;

  UserHabit({
    this.userHabitId,
    this.name,
    this.startDate,
    this.endDate,
    this.reminderMessage,
    this.userNote,
    this.isDone,
    this.percentage,
    this.planDate,
    this.planTerm,
    this.goalValue,
    this.habitId,
    this.habit,
    this.userHabitReminders,
    this.planDays,
    this.isDynamicHabit,
  });

  UserHabit.fromJson(dynamic json) {
    parseBaseParams(json);
    userHabitId = json['userHabitId'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    reminderMessage = json['reminderMessage'];
    userNote = json['userNote'];
    isDone = json['isDone'];
    percentage = Func.toDouble(json['percentage']);
    habitState = json['habitState'];
    planDate = json['planDate'];
    planTerm = json['planTerm'];
    goalValue = json['goalValue'];
    habitId = json['habitId'];
    isDynamicHabit = json['isDynamicHabit'];
    habit = json['habit'] != null ? Habit.fromJson(json['habit']) : null;
    if (json['userHabitReminders'] != null) {
      userHabitReminders = [];
      json['userHabitReminders'].forEach((v) {
        userHabitReminders?.add(UserHabitReminders.fromJson(v));
      });
    }
    if (json['planDays'] != null) {
      planDays = [];
      json['planDays'].forEach((v) {
        planDays?.add(Plan.fromJson(v));
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
    map['reminderMessage'] = reminderMessage;
    map['userNote'] = userNote;
    map['isDone'] = isDone ?? false;
    map['habitState'] = habitState;
    map['habit'] = habit;
    map['isDynamicHabit'] = isDynamicHabit ?? false;
    if (userHabitReminders != null) {
      map['userHabitReminders'] = userHabitReminders?.map((v) => v.toJson()).toList();
    }
    if (planDays != null) {
      map['planDays'] = planDays?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserHabitPlanState {
  static const New = 'New';
  static const Started = 'Started';
  static const Done = 'Done';
}
