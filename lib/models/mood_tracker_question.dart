import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';

class MoodTrackerQuestionResponse extends BaseResponse {
  int? userFeelingId;
  int? feelingQuestionId;
  String? questionText;
  String? questionType;
  bool? isLast;
  List<MoodTrackerAnswer>? answers;

  MoodTrackerQuestionResponse({
    this.userFeelingId,
    this.feelingQuestionId,
    this.questionText,
    this.questionType,
    this.isLast,
    this.answers,
  });

  MoodTrackerQuestionResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    userFeelingId = json['userFeelingId'];
    feelingQuestionId = json['feelingQuestionId'];
    questionText = json['questionText'];
    questionType = json['questionType'];
    isLast = json['isLast'];
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(MoodTrackerAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userFeelingId'] = userFeelingId;
    map['feelingQuestionId'] = feelingQuestionId;
    map['questionText'] = questionText;
    map['questionType'] = questionType;
    map['isLast'] = isLast;
    if (answers != null) {
      map['answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
