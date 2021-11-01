import 'package:habido_app/models/base_response.dart';
import 'psy_test_category_results.dart';
import 'base_response.dart';

class PsyTestResultsResponse extends BaseResponse {
  PsyTestCategoryResults? psyTestCategoryResults;

  PsyTestResultsResponse({this.psyTestCategoryResults});

  PsyTestResultsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      psyTestCategoryResults = [];
      json['data'].forEach((v) {
        psyTestCategoryResults?.add(PsyTestCategoryResults.fromJson(v));
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (psyTestCategoryResults != null) {
      map['data'] = psyTestCategoryResults?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
