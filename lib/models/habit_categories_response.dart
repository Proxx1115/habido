import 'package:habido_app/models/base_response.dart';
import 'habit_category.dart';

class HabitCategoriesResponse extends BaseResponse {
  List<HabitCategory>? habitCategoryList;

  HabitCategoriesResponse({
    this.habitCategoryList,
  });

  HabitCategoriesResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      habitCategoryList = [];
      json['data'].forEach((v) {
        habitCategoryList?.add(HabitCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitCategoryList != null) {
      map['data'] = habitCategoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
