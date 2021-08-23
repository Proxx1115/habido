class PsyTest {
  int? testId;
  int? testCatId;
  String? name;
  String? photo;
  String? color;
  String? photoBase64;
  String? description;
  bool? isRepeat;
  int? repeatInterval;
  int? repeatCnt;
  int? orderNo;

  PsyTest(
      {this.testId,
      this.testCatId,
      this.name,
      this.photo,
      this.color,
      this.photoBase64,
      this.description,
      this.isRepeat,
      this.repeatInterval,
      this.repeatCnt,
      this.orderNo});

  PsyTest.fromJson(dynamic json) {
    testId = json['testId'];
    testCatId = json['testCatId'];
    name = json['name'];
    photo = json['photo'];
    color = json['color'];
    photoBase64 = json['photoBase64'];
    description = json['description'];
    isRepeat = json['isRepeat'];
    repeatInterval = json['repeatInterval'];
    repeatCnt = json['repeatCnt'];
    orderNo = json['orderNo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['testCatId'] = testCatId;
    map['name'] = name;
    map['photo'] = photo;
    map['color'] = color;
    map['photoBase64'] = photoBase64;
    map['description'] = description;
    map['isRepeat'] = isRepeat;
    map['repeatInterval'] = repeatInterval;
    map['repeatCnt'] = repeatCnt;
    map['orderNo'] = orderNo;
    return map;
  }
}
