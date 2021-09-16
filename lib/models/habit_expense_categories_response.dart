import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/habit_expense_category.dart';

class HabitExpenseCategoriesResponse extends BaseResponse {
  List<HabitExpenseCategory>? habitExpenseCategoryList;

  HabitExpenseCategoriesResponse({
    this.habitExpenseCategoryList,
  });

  HabitExpenseCategoriesResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      habitExpenseCategoryList = [];
      json['data'].forEach((v) {
        habitExpenseCategoryList?.add(HabitExpenseCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitExpenseCategoryList != null) {
      map['data'] = habitExpenseCategoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
