import 'package:habido_app/models/base_response.dart';

class Skill extends BaseResponse {
  String? name;
  String? description;
  String? level;
  int? minValue;
  int? maxValue;
  int? currentValue;
  String? image;

  Skill({
    this.name,
    this.description,
    this.level,
    this.minValue,
    this.maxValue,
    this.currentValue,
    this.image,
  });

  Skill.fromJson(dynamic json) {
    parseBaseParams(json);

    name = json['name'];
    description = json['description'];
    level = json['level'];
    minValue = json['minValue'];
    maxValue = json['maxValue'];
    currentValue = json['currentValue'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['description'] = description;
    map['level'] = level;
    map['minValue'] = minValue;
    map['maxValue'] = maxValue;
    map['currentValue'] = currentValue;
    map['image'] = image;

    return map;
  }
}
