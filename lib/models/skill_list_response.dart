import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/skill.dart';

class SkillListResponse extends BaseResponse {
  List<Skill>? skillList;

  SkillListResponse({this.skillList});

  SkillListResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      skillList = [];
      json['data'].forEach((v) {
        skillList?.add(Skill.fromJson(v));
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (skillList != null) {
      map['data'] = skillList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
