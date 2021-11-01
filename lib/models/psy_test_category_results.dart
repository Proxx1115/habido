import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/user_psy_test_result.dart';

class PsyTestCategoryResults {
  PsyTest? latestTest;
  List<UserPsyTestResult>? psyTestResults;
  bool? isExpanded; // Local param

  PsyTestCategoryResults({this.latestTest, this.psyTestResults});

  PsyTestCategoryResults.fromJson(dynamic json) {
    latestTest = json['latestTest'];
    if (json['userTests'] != null) {
      psyTestResults = [];
      json['userTests'].forEach((v) {
        psyTestResults?.add(UserPsyTestResult.fromJson(v));
      });
    }

    isExpanded = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['latestTest'] = latestTest;

    if (psyTestResults != null) {
      map['userTests'] = psyTestResults?.map((v) => v.toJson()).toList();
    }
    map['isExpanded'] = isExpanded;

    return map;
  }
}
