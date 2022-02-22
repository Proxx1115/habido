import 'package:habido_app/ui/chat/cb_chatbots/cb_tag.dart';

class CBContent {
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
  List<CBTag>? tags;

  CBContent({
    this.contentId,
    this.title,
    this.contentPhoto,
    this.contentPhotoBase64,
    this.profilePhoto,
    this.profilePhotoBase64,
    this.intro,
    this.text,
    this.readTime,
    this.orderNo,
    this.tags,
  });

  CBContent.fromJson(dynamic json) {
    contentId = json['contentId'];
    title = json['title'];
    contentPhoto = json['contentPhoto'];
    contentPhotoBase64 = json['contentPhotoBase64'];
    profilePhoto = json['profilePhoto'];
    profilePhotoBase64 = json['profilePhotoBase64'];
    intro = json['intro'];
    text = json['text'];
    readTime = json['readTime'];
    orderNo = json['orderNo'];
    tags = json['tags'];
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
    map['readTime'] = readTime;
    map['orderNo'] = orderNo;
    map['tags'] = tags;
    return map;
  }
}
