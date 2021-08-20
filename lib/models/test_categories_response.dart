import 'package:habido_app/models/base_response.dart';

import 'test_category.dart';

class TestCategoriesResponse extends BaseResponse {
  int? currentPage;
  int? pageCount;
  int? pageSize;
  int? rowCount;
  int? firstRowOnPage;
  int? lastRowOnPage;
  List<TestCategory>? testCategoryList;

  TestCategoriesResponse(
      {this.currentPage, this.pageCount, this.pageSize, this.rowCount, this.firstRowOnPage, this.lastRowOnPage, this.testCategoryList});

  TestCategoriesResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    currentPage = json['currentPage'];
    pageCount = json['pageCount'];
    pageSize = json['pageSize'];
    rowCount = json['rowCount'];
    firstRowOnPage = json['firstRowOnPage'];
    lastRowOnPage = json['lastRowOnPage'];
    if (json['results'] != null) {
      testCategoryList = [];
      json['results'].forEach((v) {
        testCategoryList?.add(TestCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['currentPage'] = currentPage;
    map['pageCount'] = pageCount;
    map['pageSize'] = pageSize;
    map['rowCount'] = rowCount;
    map['firstRowOnPage'] = firstRowOnPage;
    map['lastRowOnPage'] = lastRowOnPage;
    if (testCategoryList != null) {
      map['results'] = testCategoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
