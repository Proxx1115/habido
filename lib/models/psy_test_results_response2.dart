import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/user_psy_test_result.dart';
import 'base_response.dart';

class PsyUserTestResultsResponse extends BaseResponse {
  List<UserPsyTestResult>? userPsyTestResults;
  PsyTest? psyTest;

  PsyUserTestResultsResponse({this.userPsyTestResults});

  PsyUserTestResultsResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    psyTest = json['latestTest'] != null ? PsyTest.fromJson(json['latestTest']) : null;

    if (json['userTests'] != null) {
      userPsyTestResults = [];
      json['userTests'].forEach((v) {
        userPsyTestResults?.add(UserPsyTestResult.fromJson(v));
        // print('test');
      });
    }



    // print('test');
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (userPsyTestResults != null) {
      map['data'] = userPsyTestResults?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
