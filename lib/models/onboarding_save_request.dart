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

  List<Map<String, dynamic>> toJsonList() {
    var map;
    if (onBoardingQuestionAns != null) {
      map = onBoardingQuestionAns?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
