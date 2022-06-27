class TestInfo {
  int? testId;
  int? testCatId;
  String? name;
  String? photo;
  String? coverPhoto;
  String? color;
  String? description;
  int? totalQuestionCnt;
  int? duration;
  bool? canStart;

  TestInfo(
      {this.testId,
      this.testCatId,
      this.name,
      this.photo,
      this.coverPhoto,
      this.color,
      this.description,
      this.totalQuestionCnt,
      this.duration,
      this.canStart});

  TestInfo.fromJson(dynamic json) {
    testId = json['testId'];
    testCatId = json['testCatId'];
    name = json['name'];
    photo = json['photo'];
    coverPhoto = json['coverPhoto'];
    color = json['color'];
    description = json['description'];
    totalQuestionCnt = json['totalQuestionCnt'];
    duration = json['duration'];
    canStart = json['canStart'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['testCatId'] = testCatId;
    map['name'] = name;
    map['photo'] = photo;
    map['coverPhoto'] = coverPhoto;
    map['color'] = color;
    map['description'] = description;
    map['totalQuestionCnt'] = totalQuestionCnt;
    map['duration'] = duration;
    map['canStart'] = canStart;

    return map;
  }
}
