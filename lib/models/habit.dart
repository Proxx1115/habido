import 'habit_goal_settings.dart';

class Habit {
  int? habitId; // 0
  int? categoryId; // avtsan
  String? name; // user habit name
  int? contentId; // 0
  int? questionId; // 0
  String? tip; // '' Зөвлөмж
  String? color; // required
  String? backgroundColor; // ''
  String? photo; // required link
  HabitGoalSettings? goalSettings;
  // 'planTerms': {'monthly': true, 'weekly': false, 'daily': true}

  Habit({
    this.habitId,
    this.categoryId,
    this.name,
    this.contentId,
    this.questionId,
    this.tip,
    this.color,
    this.photo,
    this.goalSettings,
  });

  Habit.fromJson(dynamic json) {
    habitId = json['habitId'];
    categoryId = json['categoryId'];
    name = json['name'];
    contentId = json['contentId'];
    questionId = json['questionId'];
    tip = json['tip'];
    color = json['color'];
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
    map['questionId'] = questionId;
    map['tip'] = tip;
    map['color'] = color;
    map['backgroundColor'] = backgroundColor;
    map['photo'] = photo;
    if (goalSettings != null) {
      map['goalSettings'] = goalSettings?.toJson();
    }
    return map;
  }
}
