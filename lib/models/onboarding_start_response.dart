import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/onboarding_question.dart';

class OnBoardingStartResponse extends BaseResponse {
  List<OnBoardingQuestion>? questionList;

  OnBoardingStartResponse({this.questionList});

  OnBoardingStartResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      questionList = [];
      json['data'].forEach((v) {
        questionList?.add(OnBoardingQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (questionList != null) {
      map['data'] = questionList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
