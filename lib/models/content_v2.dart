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
  int? view;
  int? readTime;
  int? orderNo;
  bool? isLiked;
  String? createdAt;

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
    this.view,
    this.readTime,
    this.tags,
    this.createdAt,
    this.isLiked,
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
    view = json['view'];
    orderNo = json['orderNo'];
    readTime = json['readTime'];
    createdAt = json['createdAt'];
    isLiked = json['isLiked'];

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
    map['view'] = view;
    map['orderNo'] = orderNo;
    map['readTime'] = readTime;
    map['createdAt'] = createdAt;
    map['isLiked'] = isLiked;

    if (tags != null) {
      map['tags'] = tags?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
