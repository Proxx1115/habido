import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/onboarding_answer.dart';

class OnBoardingQuestion {
  int? questionId;
  String? text;
  String? questionType;
  List<OnBoardingAnswer>? answers;

  OnBoardingQuestion({
    this.questionId,
    this.text,
    this.questionType,
    this.answers,
  });

  OnBoardingQuestion.fromJson(dynamic json) {
    questionId = json['questionId'];
    text = json['text'];
    questionType = json['questionType'];
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(OnBoardingAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['questionId'] = questionId;
    map['text'] = text;
    map['questionType'] = questionType;
    if (answers != null) {
      map['answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
