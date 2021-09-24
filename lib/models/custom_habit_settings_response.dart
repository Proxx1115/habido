import 'package:habido_app/models/base_response.dart';
import 'habit_goal_settings.dart';

class CustomHabitSettingsResponse extends BaseResponse {
  CustomHabitSettingsResponse({
    this.colorList,
    this.iconList,
    this.goalSettingsList,
  });

  CustomHabitSettingsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['colors'] != null) {
      colorList = [];
      json['colors'].forEach((v) {
        colorList?.add(CustomHabitColor.fromJson(v));
      });
    }
    if (json['icons'] != null) {
      iconList = [];
      json['icons'].forEach((v) {
        iconList?.add(CustomHabitIcon.fromJson(v));
      });
    }
    if (json['goalSettings'] != null) {
      goalSettingsList = [];
      json['goalSettings'].forEach((v) {
        goalSettingsList?.add(HabitGoalSettings.fromJson(v));
      });
    }
  }

  List<CustomHabitColor>? colorList;
  List<CustomHabitIcon>? iconList;
  List<HabitGoalSettings>? goalSettingsList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (colorList != null) {
      map['colors'] = colorList?.map((v) => v.toJson()).toList();
    }
    if (iconList != null) {
      map['icons'] = iconList?.map((v) => v.toJson()).toList();
    }
    if (goalSettingsList != null) {
      map['goalSettings'] = goalSettingsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CustomHabitColor {
  CustomHabitColor({
    this.primaryColor,
    this.backgroundColor,
  });

  CustomHabitColor.fromJson(dynamic json) {
    primaryColor = json['color'];
    backgroundColor = json['bgColor'];
  }

  String? primaryColor;
  String? backgroundColor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['color'] = primaryColor;
    map['bgColor'] = backgroundColor;
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
