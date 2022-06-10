import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/content_tag_v2.dart';

class ContentV2 extends BaseResponse {
  int? contentId;
  String? title;
  String? contentPhoto;
  String? contentPhotoBase64;

  String? profilePhoto;
  String? profilePhotoBase64;
  String? intro;
  String? text;
  int? readTime;
  int? orderNo;

  List<ContentTagV2>? tags;

  ContentV2({
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
    this.readTime,
    this.tags,
  });

  ContentV2.fromJson(dynamic json) {
    parseBaseParams(json);

    contentId = json['contentId'];
    title = json['title'];
    contentPhoto = json['contentPhoto'];
    contentPhotoBase64 = json['contentPhotoBase64'];

    profilePhoto = json['profilePhoto'];
    profilePhotoBase64 = json['profilePhotoBase64'];
    intro = json['intro'];
    text = json['text'];
    orderNo = json['orderNo'];
    readTime = json['readTime'];

    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(ContentTagV2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['contentId'] = contentId;
    map['title'] = title;
    map['contentPhoto'] = contentPhoto;
    map['contentPhotoBase64'] = contentPhotoBase64;
    map['profilePhoto'] = profilePhoto;
    map['profilePhotoBase64'] = profilePhotoBase64;
    map['intro'] = intro;
    map['text'] = text;
    map['orderNo'] = orderNo;
    map['readTime'] = readTime;

    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
