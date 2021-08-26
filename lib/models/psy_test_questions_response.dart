import 'package:habido_app/models/base_response.dart';

import 'psy_test_question.dart';

class PsyTestQuestionsResponse extends BaseResponse {
  int? testId;
  int? userTestId;
  List<PsyTestQuestion>? questionList;

  PsyTestQuestionsResponse({this.testId, this.userTestId, this.questionList});

  PsyTestQuestionsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    testId = json['testId'];
    userTestId = json['userTestId'];
    if (json['dataTestQuestionRes'] != null) {
      questionList = [];
      json['dataTestQuestionRes'].forEach((v) {
        questionList?.add(PsyTestQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['testId'] = testId;
    map['userTestId'] = userTestId;
    if (questionList != null) {
      map['dataTestQuestionRes'] = questionList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
