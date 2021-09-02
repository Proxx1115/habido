class HabitCategoriesAchievement {
  String? habitCatName;
  String? categoryColor;
  int? habitCatPercentage;

  HabitCategoriesAchievement({
      this.habitCatName, 
      this.categoryColor, 
      this.habitCatPercentage});

  HabitCategoriesAchievement.fromJson(dynamic json) {
    habitCatName = json['habitCatName'];
    categoryColor = json['categoryColor'];
    habitCatPercentage = json['habitCatPercentage'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['habitCatName'] = habitCatName;
    map['categoryColor'] = categoryColor;
    map['habitCatPercentage'] = habitCatPercentage;
    return map;
  }

}