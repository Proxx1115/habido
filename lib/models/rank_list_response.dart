import 'package:habido_app/models/base_response.dart';

import 'rank.dart';

class RankListResponse extends BaseResponse {
  List<Rank>? rankList;

  RankListResponse({
    this.rankList,
  });

  RankListResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      rankList = [];
      json['data'].forEach((v) {
        rankList?.add(Rank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (rankList != null) {
      map['data'] = rankList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
