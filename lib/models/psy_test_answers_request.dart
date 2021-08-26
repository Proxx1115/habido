import 'package:habido_app/models/base_request.dart';

import 'psy_test_question_answer.dart';

class PsyTestAnswersRequest extends BaseRequest {
  int? testId;
  int? userTestId;
  List<PsyTestQuestionAnswer>? dataTestQuestionAns;

  PsyTestAnswersRequest({this.testId, this.userTestId, this.dataTestQuestionAns});

  PsyTestAnswersRequest.fromJson(dynamic json) {
    testId = json['testId'];
    userTestId = json['userTestId'];
    if (json['dataTestQuestionAns'] != null) {
      dataTestQuestionAns = [];
      json['dataTestQuestionAns'].forEach((v) {
        dataTestQuestionAns?.add(PsyTestQuestionAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['userTestId'] = userTestId;
    if (dataTestQuestionAns != null) {
      map['dataTestQuestionAns'] = dataTestQuestionAns?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
