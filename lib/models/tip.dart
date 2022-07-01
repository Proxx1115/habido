class Tip {
  int? tipId;
  int? categoryId;
  String? title;
  String? description;
  String? mediaType;
  String? link;
  int? orderNo;

  Tip({
    this.tipId,
    this.categoryId,
    this.title,
    this.description,
    this.mediaType,
    this.link,
    this.orderNo,
  });

  Tip.fromJson(dynamic json) {
    tipId = json['tipId'];
    categoryId = json['categoryId'];
    title = json['title'];
    description = json['description'];
    mediaType = json['mediaType'];
    link = json['link'];
    orderNo = json['orderNo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tipId'] = tipId;
    map['categoryId'] = categoryId;
    map['title'] = title;
    map['description'] = description;
    map['mediaType'] = mediaType;
    map['link'] = link;
    map['orderNo'] = orderNo;
    return map;
  }
}
