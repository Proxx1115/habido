import 'package:habido_app/models/base_response.dart';

import 'user_habit_expense_category.dart';

class HabitFinanceTotalAmountResponse extends BaseResponse {
  String? totalAmount;
  List<UserHabitExpenseCategory>? expenseCategories;

  HabitFinanceTotalAmountResponse({this.totalAmount, this.expenseCategories});

  HabitFinanceTotalAmountResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    totalAmount = json['totalAmount'];
    if (json['expenseCategories'] != null) {
      expenseCategories = [];
      json['expenseCategories'].forEach((v) {
        expenseCategories?.add(UserHabitExpenseCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['totalAmount'] = totalAmount;
    if (expenseCategories != null) {
      map['expenseCategories'] = expenseCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
