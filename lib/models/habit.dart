class HdGoalType {
  // Үндсэн зорилго
  int? goalName;
  int? goalMin; // Feeling ued utga baihgui
  int? goalMax;

  // Дадал биелүүлэх tools
  int? toolType; // Minute, Hour, Count, Feeling (emoji), Satisfaction, Amount (Finance), Music, Animation,
  int? toolContent; // Минут, Цаг, Аяга, 'emoji', 'camera', '₮', 'music link', 'Tree animation, ... animation',
}

class Habit {
  int? habitId;
  int? categoryId;
  String? name;
  int? contentId;
  String? note;
  String? color;
  String? photo;
  HdGoalType? habitGoalType;

  Habit({
    this.habitId,
    this.categoryId,
    this.name,
    this.contentId,
    this.note,
  });

  Habit.fromJson(dynamic json) {
    habitId = json['habitId'];
    categoryId = json['categoryId'];
    name = json['name'];
    contentId = json['contentId'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['habitId'] = habitId;
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['contentId'] = contentId;
    map['note'] = note;
    return map;
  }
}
