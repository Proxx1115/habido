class Tip {
  int? tipId;
  String? title;
  String? description;
  String? mediaType;
  String? link;
  String? photoBase64;
  bool? featured;

  Tip({this.tipId, this.title, this.description, this.mediaType, this.link, this.photoBase64, this.featured});

  Tip.fromJson(dynamic json) {
    tipId = json['tipId'];
    title = json['title'];
    description = json['description'];
    mediaType = json['mediaType'];
    link = json['link'];
    photoBase64 = json['photoBase64'];
    featured = json['featured'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tipId'] = tipId;
    map['title'] = title;
    map['description'] = description;
    map['mediaType'] = mediaType;
    map['link'] = link;
    map['photoBase64'] = photoBase64;
    map['featured'] = featured;
    return map;
  }
}
