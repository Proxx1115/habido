import 'package:habido_app/models/base_request.dart';

class PsyTestReview extends BaseRequest {
  int? testId;
  double? score;
  PsyTestReview({this.testId, this.score});

  PsyTestReview.fromJson(dynamic json) {
    testId = json['testId'];
    score = json['score'];
  }
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['score'] = score;

    return map;
  }
}
