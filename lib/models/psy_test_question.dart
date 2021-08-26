import 'psy_test_answer.dart';

class PsyTestQuestion {
  int? questionId;
  int? testId;
  String? text;
  bool? isTimeLimit;
  int? timeLimit;
  bool? isAnsOrder;
  List<PsyTestAnswer>? testAnswers;

  PsyTestQuestion({
      this.questionId, 
      this.testId, 
      this.text, 
      this.isTimeLimit, 
      this.timeLimit, 
      this.isAnsOrder, 
      this.testAnswers});

  PsyTestQuestion.fromJson(dynamic json) {
    questionId = json['questionId'];
    testId = json['testId'];
    text = json['text'];
    isTimeLimit = json['isTimeLimit'];
    timeLimit = json['timeLimit'];
    isAnsOrder = json['isAnsOrder'];
    if (json['testAnswers'] != null) {
      testAnswers = [];
      json['testAnswers'].forEach((v) {
        testAnswers?.add(PsyTestAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['questionId'] = questionId;
    map['testId'] = testId;
    map['text'] = text;
    map['isTimeLimit'] = isTimeLimit;
    map['timeLimit'] = timeLimit;
    map['isAnsOrder'] = isAnsOrder;
    if (testAnswers != null) {
      map['testAnswers'] = testAnswers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}