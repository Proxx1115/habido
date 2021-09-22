import 'habit_goal_settings.dart';

class Habit {
  int? habitId; // 0
  int? categoryId; // avtsan
  String? name; // user habit name
  int? contentId; // 0
  int? questionId; // 0
  String? note; // ''
  String? color; // required
  String? backgroundColor; // ''
  String? photo; // required link
  HabitGoalSettings? goalSettings; //

  Habit({
    this.habitId,
    this.categoryId,
    this.name,
    this.contentId,
    this.questionId,
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
    questionId = json['questionId'];
    note = json['note'];
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
