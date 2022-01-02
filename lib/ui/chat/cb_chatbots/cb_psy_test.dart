class CBPsyTest {
  int? testId;
  int? testCatId;
  String? name;
  String? photo;
  String? photoBase64;
  String? coverPhoto;
  String? coverPhotoBase64;
  String? color;
  String? description;
  bool? isRepeat;
  int? repeatInterval;
  int? repeatCnt;
  int? orderNo;

  CBPsyTest({
    this.testId,
    this.testCatId,
    this.name,
    this.photo,
    this.photoBase64,
    this.coverPhoto,
    this.coverPhotoBase64,
    this.color,
    this.description,
    this.isRepeat,
    this.repeatInterval,
    this.repeatCnt,
    this.orderNo,
  });

  CBPsyTest.fromJson(dynamic json) {
    testId = json['testId'];
    testCatId = json['testCatId'];
    name = json['name'];
    photo = json['photo'];
    photoBase64 = json['photoBase64'];
    coverPhoto = json['coverPhoto'];
    coverPhotoBase64 = json['coverPhotoBase64'];
    color = json['color'];
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
    map['photoBase64'] = photoBase64;
    map['coverPhoto'] = coverPhoto;
    map['coverPhotoBase64'] = coverPhotoBase64;
    map['color'] = color;
    map['description'] = description;
    map['isRepeat'] = isRepeat;
    map['repeatInterval'] = repeatInterval;
    map['repeatCnt'] = repeatCnt;
    map['orderNo'] = orderNo;
    return map;
  }
}
