class SuggestedHabit {
  int? habitId;
  String? name;
  String? photo;

  SuggestedHabit({
    this.habitId,
    this.name,
    this.photo,
  });

  SuggestedHabit.fromJson(dynamic json) {
    habitId = json['habitId'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['habitId'] = habitId;
    map['name'] = name;
    map['photo'] = photo;
    return map;
  }
}
