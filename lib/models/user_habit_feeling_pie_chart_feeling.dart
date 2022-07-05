class UserHabitFeelingPieChartFeeling {
  String? name;
  int? count;
  int? index;

  UserHabitFeelingPieChartFeeling({this.name, this.count});

  UserHabitFeelingPieChartFeeling.fromJson(dynamic json) {
    name = json['name'];
    count = json['count'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['count'] = count;
    map['index'] = index;
    return map;
  }
}
