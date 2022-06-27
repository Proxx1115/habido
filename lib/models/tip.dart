class Tip {
  int? tipId;
  String? title;
  String? description;
  String? mediaType;
  String? link;
  String? bgColor;
  bool? featured;

  Tip({this.tipId, this.title, this.description, this.mediaType, this.link, this.bgColor, this.featured});

  Tip.fromJson(dynamic json) {
    print("goysda");
    tipId = json['tipId'];
    title = json['title'];
    description = json['description'];
    mediaType = json['mediaType'];
    link = json['link'];
    bgColor = json['bgColor'];
    featured = json['featured'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tipId'] = tipId;
    map['title'] = title;
    map['description'] = description;
    map['mediaType'] = mediaType;
    map['link'] = link;
    map['bgColor'] = bgColor;
    map['featured'] = featured;
    return map;
  }
}
