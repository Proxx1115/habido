import 'package:habido_app/models/base_response.dart';

class BadgeModule extends BaseResponse {
  String? name;
  String? imageLink;
  String? requirement;
  int? acquiredCount;

  BadgeModule({
    this.name,
    this.imageLink,
    this.requirement,
    this.acquiredCount,
  });

  BadgeModule.fromJson(dynamic json) {
    parseBaseParams(json);

    name = json['name'];
    imageLink = json['imageLink'];
    requirement = json['requirement'];
    acquiredCount = json['acquiredCount'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['imageLink'] = imageLink;
    map['requirement'] = requirement;
    map['acquiredCount'] = acquiredCount;

    return map;
  }
}
