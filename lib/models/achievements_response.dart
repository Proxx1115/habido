import 'package:habido_app/models/base_response.dart';

import 'all_time_achievement.dart';
import 'monthly_achievement.dart';
import 'habit_categories_achievement.dart';

class AchievementsResponse extends BaseResponse {
  AllTimeAchievement? allTimeAchievement;
  MonthlyAchievement? monthlyAchievement;
  List<HabitCategoriesAchievement>? habitCategoryAchievements;

  AchievementsResponse({this.allTimeAchievement, this.monthlyAchievement, this.habitCategoryAchievements});

  AchievementsResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    allTimeAchievement = json['allTimeAccomp'] != null ? AllTimeAchievement.fromJson(json['allTimeAccomp']) : null;
    monthlyAchievement = json['monthlyAccomp'] != null ? MonthlyAchievement.fromJson(json['monthlyAccomp']) : null;
    if (json['habitCatAchievements'] != null) {
      habitCategoryAchievements = [];
      json['habitCatAchievements'].forEach((v) {
        habitCategoryAchievements?.add(HabitCategoriesAchievement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (allTimeAchievement != null) {
      map['allTimeAccomp'] = allTimeAchievement?.toJson();
    }
    if (monthlyAchievement != null) {
      map['monthlyAccomp'] = monthlyAchievement?.toJson();
    }
    if (habitCategoryAchievements != null) {
      map['habitCatAchievements'] = habitCategoryAchievements?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
