import 'tags.dart';

class Content {
  int? contentId;
  String? title;
  String? contentPhoto;
  String? contentPhotoBase64;
  String? coverPhoto;
  String? coverPhotoBase64;
  String? text;
  int? orderNo;
  List<Tags>? tags;
  int? readTime;

  Content({
    this.contentId,
    this.title,
    this.contentPhoto,
    this.contentPhotoBase64,
    this.coverPhoto,
    this.coverPhotoBase64,
    this.text,
    this.orderNo,
    this.tags,
    this.readTime,
  });

  Content.fromJson(dynamic json) {
    contentId = json['contentId'];
    title = json['title'];
    contentPhoto = json['contentPhoto'];
    contentPhotoBase64 = json['contentPhotoBase64'];
    coverPhoto = json['coverPhoto'];
    coverPhotoBase64 = json['coverPhotoBase64'];
    text = json['text'];
    orderNo = json['orderNo'];
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(Tags.fromJson(v));
      });
    }
    readTime = json['readTime'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['contentId'] = contentId;
    map['title'] = title;
    map['contentPhoto'] = contentPhoto;
    map['contentPhotoBase64'] = contentPhotoBase64;
    map['coverPhoto'] = coverPhoto;
    map['coverPhotoBase64'] = coverPhotoBase64;
    map['text'] = text;
    map['orderNo'] = orderNo;
    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    map['readTime'] = readTime;
    return map;
  }
}
