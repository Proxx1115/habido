import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/habit_template.dart';

class DashboardHabitTemplatesResponse extends BaseResponse {
  List<HabitTemplate>? habitTemplateList;

  DashboardHabitTemplatesResponse({
    this.habitTemplateList,
  });

  DashboardHabitTemplatesResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      habitTemplateList = [];
      json['data'].forEach((v) {
        habitTemplateList?.add(HabitTemplate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitTemplateList != null) {
      map['data'] = habitTemplateList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
