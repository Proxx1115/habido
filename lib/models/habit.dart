import 'package:habido_app/models/base_response.dart';

import 'habit_goal_settings.dart';
import 'habit_plan_terms.dart';

class Habit extends BaseResponse {
  int? habitId; // 0
  int? categoryId; // avtsan
  String? name; // user habit name
  int? contentId; // 0
  int? questionId; // 0
  String? tip; // '' Зөвлөмж
  String? noteTitle; // '' Тэмдэглэл хөтлөхийн гарчиг текст
  String? color; // required
  String? backgroundColor; // ''
  String? photo; // required link
  HabitGoalSettings? goalSettings;
  HabitPlanTerms? planTerms;

  Habit({
    this.habitId,
    this.categoryId,
    this.name,
    this.contentId,
    this.questionId,
    this.tip,
    this.noteTitle,
    this.color,
    this.photo,
    this.goalSettings,
    this.planTerms,
  });

  Habit.fromJson(dynamic json) {
    habitId = json['habitId'];
    categoryId = json['categoryId'];
    name = json['name'];
    contentId = json['contentId'];
    questionId = json['questionId'];
    tip = json['tip'];
    noteTitle = json['noteTitle'];
    color = json['color'];
    backgroundColor = json['backgroundColor'];
    photo = json['photo'];
    goalSettings = json['goalSettings'] != null ? HabitGoalSettings.fromJson(json['goalSettings']) : null;
    planTerms = json['planTerms'] != null ? HabitPlanTerms.fromJson(json['planTerms']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['habitId'] = habitId;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['contentId'] = contentId;
    map['questionId'] = questionId;
    map['tip'] = tip;
    map['noteTitle'] = noteTitle;
    map['color'] = color;
    map['backgroundColor'] = backgroundColor;
    map['photo'] = photo;
    if (goalSettings != null) {
      map['goalSettings'] = goalSettings?.toJson();
    }
    if (planTerms != null) {
      map['planTerms'] = planTerms?.toJson();
    }
    return map;
  }
}
