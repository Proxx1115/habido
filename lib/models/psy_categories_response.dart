import 'package:habido_app/models/base_response.dart';

import 'psy_category.dart';

class PsyCategoriesResponse extends BaseResponse {
  List<PsyCategory>? psyCategoryList;

  PsyCategoriesResponse({
    this.psyCategoryList,
  });

  PsyCategoriesResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      psyCategoryList = [];
      json['data'].forEach((v) {
        psyCategoryList?.add(PsyCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (psyCategoryList != null) {
      map['data'] = psyCategoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
