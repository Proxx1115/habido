import 'package:habido_app/models/base_response.dart';
import 'habit_goal_settings.dart';

class CustomHabitSettingsResponse extends BaseResponse {
  CustomHabitSettingsResponse({
    this.colors,
    this.icons,
    this.goalSettings,
  });

  CustomHabitSettingsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['colors'] != null) {
      colors = [];
      json['colors'].forEach((v) {
        colors?.add(CustomHabitColor.fromJson(v));
      });
    }
    if (json['icons'] != null) {
      icons = [];
      json['icons'].forEach((v) {
        icons?.add(CustomHabitIcon.fromJson(v));
      });
    }
    if (json['goalSettings'] != null) {
      goalSettings = [];
      json['goalSettings'].forEach((v) {
        goalSettings?.add(HabitGoalSettings.fromJson(v));
      });
    }
  }

  List<CustomHabitColor>? colors;
  List<CustomHabitIcon>? icons;
  List<HabitGoalSettings>? goalSettings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (colors != null) {
      map['colors'] = colors?.map((v) => v.toJson()).toList();
    }
    if (icons != null) {
      map['icons'] = icons?.map((v) => v.toJson()).toList();
    }
    if (goalSettings != null) {
      map['goalSettings'] = goalSettings?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CustomHabitColor {
  CustomHabitColor({
    this.color,
    this.bgColor,
  });

  CustomHabitColor.fromJson(dynamic json) {
    color = json['color'];
    bgColor = json['bgColor'];
  }

  String? color;
  String? bgColor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['color'] = color;
    map['bgColor'] = bgColor;
    return map;
  }
}

class CustomHabitIcon {
  CustomHabitIcon({
    this.link,
  });

  CustomHabitIcon.fromJson(dynamic json) {
    link = json['link'];
  }

  String? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['link'] = link;
    return map;
  }
}
