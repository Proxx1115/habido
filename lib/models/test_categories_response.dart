import 'package:habido_app/models/base_response.dart';

import 'test_category.dart';

class TestCategoriesResponse extends BaseResponse {
  List<TestCategory>? testCategoryList;

  TestCategoriesResponse({
    this.testCategoryList,
  });

  TestCategoriesResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      testCategoryList = [];
      json['data'].forEach((v) {
        testCategoryList?.add(TestCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (testCategoryList != null) {
      map['data'] = testCategoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
