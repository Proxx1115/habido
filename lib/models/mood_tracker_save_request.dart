import 'package:habido_app/models/base_request.dart';

class MoodTrackerSaveRequest extends BaseRequest {
  int? userFeelingId;
  int? questionId;
  List<MoodTrackerSaveAnswer>? answers;

  MoodTrackerSaveRequest({this.userFeelingId, this.questionId, this.answers});

  MoodTrackerSaveRequest.fromJson(dynamic json) {
    userFeelingId = json["userFeelingId"];
    questionId = json["questionId"];
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(MoodTrackerSaveAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userFeelingId"] = userFeelingId;
    map["questionId"] = questionId;
    if (answers != null) {
      map['answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MoodTrackerSaveAnswer {
  int? answerId;
  String? text;

  MoodTrackerSaveAnswer({this.answerId, this.text});

  MoodTrackerSaveAnswer.fromJson(dynamic json) {
    answerId = json["answerId"];
    text = json["text"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["answerId"] = answerId;
    map["text"] = text;
    return map;
  }
}
