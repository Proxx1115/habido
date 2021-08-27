import 'package:habido_app/models/user_psy_test_result.dart';

class PsyTestCategoryResults {
  String? categoryName;
  List<UserPsyTestResult>? psyTestResults;
  bool? isExpanded; // Local param

  PsyTestCategoryResults({this.categoryName, this.psyTestResults});

  PsyTestCategoryResults.fromJson(dynamic json) {
    categoryName = json['categoryName'];
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
    map['categoryName'] = categoryName;

    if (psyTestResults != null) {
      map['userTests'] = psyTestResults?.map((v) => v.toJson()).toList();
    }
    map['isExpanded'] = isExpanded;

    return map;
  }
}
