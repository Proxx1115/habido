import 'habit_goal_settings.dart';

class Habit {
  int? habitId;
  int? categoryId;
  String? name;
  int? contentId;
  String? note;
  String? color;
  String? backgroundColor;
  String? photo;
  HabitGoalSettings? goalSettings;

  Habit({
    this.habitId,
    this.categoryId,
    this.name,
    this.contentId,
    this.note,
    this.color,
    this.photo,
    this.goalSettings,
  });

  Habit.fromJson(dynamic json) {
    habitId = json['habitId'];
    categoryId = json['categoryId'];
    name = json['name'];
    contentId = json['contentId'];
    note = json['note'];
    color = json['note'];
    backgroundColor = json['backgroundColor'];
    photo = json['photo'];
    goalSettings = json['goalSettings'] != null ? HabitGoalSettings.fromJson(json['goalSettings']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['habitId'] = habitId;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['contentId'] = contentId;
    map['note'] = note;
    map['color'] = color;
    map['backgroundColor'] = backgroundColor;
    map['photo'] = photo;
    if (goalSettings != null) {
      map['goalSettings'] = goalSettings?.toJson();
    }
    return map;
  }
}
