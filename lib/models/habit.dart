class Habit {
  int? habitId;
  int? categoryId;
  String? name;
  bool? hasGoal;
  int? goalTypeId;
  int? toolId;
  int? contentId;
  bool? isFinance;
  String? note;

  Habit({this.habitId, this.categoryId, this.name, this.hasGoal, this.goalTypeId, this.toolId, this.contentId, this.isFinance, this.note});

  Habit.fromJson(dynamic json) {
    habitId = json['habitId'];
    categoryId = json['categoryId'];
    name = json['name'];
    hasGoal = json['hasGoal'];
    goalTypeId = json['goalTypeId'];
    toolId = json['toolId'];
    contentId = json['contentId'];
    isFinance = json['isFinance'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['habitId'] = habitId;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['hasGoal'] = hasGoal;
    map['goalTypeId'] = goalTypeId;
    map['toolId'] = toolId;
    map['contentId'] = contentId;
    map['isFinance'] = isFinance;
    map['note'] = note;
    return map;
  }
}
