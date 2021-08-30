class HabitCategory {
  int? categoryId;
  String? name;
  String? photo;
  String? color;

  HabitCategory({
    this.categoryId,
    this.name,
    this.photo,
    this.color,
  });

  HabitCategory.fromJson(dynamic json) {
    categoryId = json['categoryId'];
    name = json['name'];
    photo = json['photo'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['photo'] = photo;
    map['color'] = color;

    return map;
  }
}
