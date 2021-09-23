class HabitCategory {
  int? categoryId;
  int? userId;
  String? name;
  String? photo;
  String? color;
  String? backgroundColor;

  HabitCategory({
    this.categoryId,
    this.userId,
    this.name,
    this.photo,
    this.color,
    this.backgroundColor,
  });

  HabitCategory.fromJson(dynamic json) {
    categoryId = json['categoryId'];
    userId = json['userId'];
    name = json['name'];
    photo = json['photo'];
    color = json['color'];
    backgroundColor = json['backGroundColor'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryId'] = categoryId;
    map['userId'] = userId;
    map['name'] = name;
    map['photo'] = photo;
    map['color'] = color;
    map['backgroundColor'] = backgroundColor;

    return map;
  }
}
