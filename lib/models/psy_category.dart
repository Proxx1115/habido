class PsyCategory {
  int? testCatId;
  String? name;
  String? photo;
  String? color;
  String? photoBase64;
  int? orderNo;
  bool? isActive;

  PsyCategory({this.testCatId, this.name, this.photo, this.color, this.photoBase64, this.orderNo, this.isActive});

  PsyCategory.fromJson(dynamic json) {
    testCatId = json['testCatId'];
    name = json['name'];
    photo = json['photo'];
    color = json['color'];
    photoBase64 = json['photoBase64'];
    orderNo = json['orderNo'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testCatId'] = testCatId;
    map['name'] = name;
    map['photo'] = photo;
    map['color'] = color;
    map['photoBase64'] = photoBase64;
    map['orderNo'] = orderNo;
    map['isActive'] = isActive;
    return map;
  }
}
