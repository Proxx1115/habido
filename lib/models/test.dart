class Test {
  int? testId;
  String? name;
  String? photo;
  bool? hasTaken;
  Test({
    this.testId,
    this.name,
    this.photo,
    this.hasTaken,
  });

  Test.fromJson(dynamic json) {
    testId = json['testId'];
    name = json['name'];
    photo = json['photo'];
    hasTaken = json['hasTaken'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['name'] = name;
    map['photo'] = photo;
    map['hasTaken'] = hasTaken;

    return map;
  }
}
