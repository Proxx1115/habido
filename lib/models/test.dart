class Test {
  int? testId;
  String? name;
  String? photo;
  Test({this.testId, this.name, this.photo});

  Test.fromJson(dynamic json) {
    testId = json['testId'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['name'] = name;
    map['photo'] = photo;
    return map;
  }
}
