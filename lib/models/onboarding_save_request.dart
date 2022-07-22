import 'package:habido_app/models/base_request.dart';
import 'package:habido_app/models/onboarding_question.dart';

class OnBoardingSaveRequest extends BaseRequest {
  List<OnBoardingQuestion>? onBoardingQuestionAns;

  OnBoardingSaveRequest({this.onBoardingQuestionAns});

  OnBoardingSaveRequest.fromJson(dynamic json) {
    if (json['data'] != null) {
      onBoardingQuestionAns = [];
      json['data'].forEach((v) {
        onBoardingQuestionAns?.add(OnBoardingQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (onBoardingQuestionAns != null) {
      map['data'] = onBoardingQuestionAns?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
