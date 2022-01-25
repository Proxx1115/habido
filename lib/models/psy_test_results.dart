import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/user_psy_test_result.dart';

class PsyTestResults {
  PsyTest? LatestTest;
  List<UserPsyTestResult>? psyTestResults;
  bool? isExpanded; // Local param

  PsyTestResults({this.LatestTest, this.psyTestResults});

  PsyTestResults.fromJson(dynamic json) {
    LatestTest = json['latestTest'];
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
    map['LatestTest'] = LatestTest;

    if (psyTestResults != null) {
      map['userTests'] = psyTestResults?.map((v) => v.toJson()).toList();
    }
    map['isExpanded'] = isExpanded;

    return map;
  }
}