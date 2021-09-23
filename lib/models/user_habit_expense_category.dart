import 'package:habido_app/utils/func.dart';

class UserHabitExpenseCategory {
  String? expenseCatName;
  String? categoryColor;
  double? habitCatPercentage;

  UserHabitExpenseCategory({this.expenseCatName, this.categoryColor, this.habitCatPercentage});

  UserHabitExpenseCategory.fromJson(dynamic json) {
    expenseCatName = json['expenseCatName'];
    categoryColor = json['categoryColor'];
    habitCatPercentage = Func.toDouble(json['habitCatPercentage']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['expenseCatName'] = expenseCatName;
    map['categoryColor'] = categoryColor;
    map['habitCatPercentage'] = habitCatPercentage;
    return map;
  }
}
