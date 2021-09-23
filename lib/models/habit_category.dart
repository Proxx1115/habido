class HabitCategory {
  int? categoryId;
  String? name;
  String? photo;
  String? color;
  String? backgroundColor;

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
    backgroundColor = json['backgroundColor'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryId'] = categoryId;
    map['name'] = name;
    map['photo'] = photo;
    map['color'] = color;
    map['backgroundColor'] = backgroundColor;

    return map;
  }
}
