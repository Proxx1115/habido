import 'user_psy_test_results.dart';

class PsyTestResultsResponse {
  String? categoryName;
  List<UserPsyTestResults>? userTests;

  PsyTestResultsResponse({this.categoryName, this.userTests});

  PsyTestResultsResponse.fromJson(dynamic json) {
    categoryName = json['categoryName'];
    if (json['userTests'] != null) {
      userTests = [];
      json['userTests'].forEach((v) {
        userTests?.add(UserPsyTestResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryName'] = categoryName;
    if (userTests != null) {
      map['userTests'] = userTests?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
