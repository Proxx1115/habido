import 'package:habido_app/models/plan.dart';
import 'package:habido_app/models/user_habit_reminders.dart';

class HabitTemplate {
  int? templateId;
  int? habitId;
  String? name;
  int? duration;
  String? icon;
  String? color;
  String? planTerm;
  String? goalValue;
  List<UserHabitReminders>? templateReminders;
  List<Plan>? planDays;

  HabitTemplate({
    this.templateId,
    this.habitId,
    this.duration,
    this.name,
    this.icon,
    this.color,
    this.planTerm,
    this.planDays,
    this.goalValue,
  });

  HabitTemplate.fromJson(dynamic json) {
    templateId = json['templateId'];
    habitId = json['habitId'];
    duration = json['duration'];
    name = json['name'];
    icon = json['icon'];
    color = json['color'];
    planTerm = json['planTerm'];
    goalValue = json['goalValue'];
    if (json['templateReminders'] != null) {
      templateReminders = [];
      json['templateReminders'].forEach((v) {
        templateReminders?.add(UserHabitReminders.fromJson(v));
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
    map['templateId'] = templateId;
    map['habitId'] = habitId;
    map['duration'] = duration;
    map['name'] = name;
    map['icon'] = icon;
    map['color'] = color;
    map['planTerm'] = planTerm;
    map['goalValue'] = goalValue;
    if (templateReminders != null) {
      map['templateReminders'] = templateReminders?.map((v) => v.toJson()).toList();
    }
    if (planDays != null) {
      map['planDays'] = planDays?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
