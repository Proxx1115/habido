import 'package:habido_app/models/test.dart';

class TestNameWithTests {
  String? testCatName;
  List<Test>? tests;

  TestNameWithTests({this.testCatName, this.tests});

  TestNameWithTests.fromJson(dynamic json) {
    testCatName = json['testCatName'];
    if (json['tests'] != null) {
      tests = [];
      json['tests'].forEach((v) {
        tests?.add(Test.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['testCatName'] = testCatName;
    if (tests != null) {
      map['tests'] = tests?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
