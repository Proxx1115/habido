import 'package:habido_app/models/base_response.dart';

import 'content_tag.dart';

class Content extends BaseResponse {
  int? contentId;
  String? title;
  String? contentPhoto;
  String? contentPhotoBase64;

  // String? coverPhoto;
  // String? coverPhotoBase64;
  String? profilePhoto;
  String? profilePhotoBase64;
  String? intro;
  String? text;
  int? orderNo;
  List<ContentTag>? tags;
  int? readTime;

  Content({
    this.contentId,
    this.title,
    this.contentPhoto,
    this.contentPhotoBase64,
    // this.coverPhoto,
    // this.coverPhotoBase64,
    this.profilePhoto,
    this.profilePhotoBase64,
    this.intro,
    this.text,
    this.orderNo,
    this.tags,
    this.readTime,
  });

  Content.fromJson(dynamic json) {
    parseBaseParams(json);

    contentId = json['contentId'];
    title = json['title'];
    contentPhoto = json['contentPhoto'];
    contentPhotoBase64 = json['contentPhotoBase64'];
    // coverPhoto = json['coverPhoto'];
    // coverPhotoBase64 = json['coverPhotoBase64'];
    profilePhoto = json['profilePhoto'];
    profilePhotoBase64 = json['profilePhotoBase64'];
    intro = json['intro'];
    text = json['text'];
    orderNo = json['orderNo'];
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(ContentTag.fromJson(v));
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
    // map['coverPhoto'] = coverPhoto;
    // map['coverPhotoBase64'] = coverPhotoBase64;
    map['profilePhoto'] = profilePhoto;
    map['profilePhotoBase64'] = profilePhotoBase64;
    map['intro'] = intro;
    map['text'] = text;
    map['orderNo'] = orderNo;
    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    map['readTime'] = readTime;
    return map;
  }
}
