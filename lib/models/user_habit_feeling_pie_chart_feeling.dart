class UserHabitFeelingPieChartFeeling {
  String? name;
  int? count;

  UserHabitFeelingPieChartFeeling({this.name, this.count});

  UserHabitFeelingPieChartFeeling.fromJson(dynamic json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['count'] = count;
    return map;
  }
}
