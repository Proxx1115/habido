import 'package:habido_app/models/badge_module.dart';
import 'package:habido_app/models/base_response.dart';

class BadgeListResponse extends BaseResponse {
  List<BadgeModule>? badgeList;

  BadgeListResponse({this.badgeList});

  BadgeListResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      badgeList = [];
      json['data'].forEach((v) {
        badgeList?.add(BadgeModule.fromJson(v));
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (badgeList != null) {
      map['data'] = badgeList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
