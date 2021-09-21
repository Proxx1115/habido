import 'base_response.dart';

class HabitQuestionResponse extends BaseResponse {
  HabitQuestionResponse({
    this.habitQuestion,
    this.answers,
  });

  HabitQuestionResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    habitQuestion = json['habitQuestion'] != null ? HabitQuestion.fromJson(json['habitQuestion']) : null;
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(HabitAnswer.fromJson(v));
      });
    }
  }

  HabitQuestion? habitQuestion;
  List<HabitAnswer>? answers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (habitQuestion != null) {
      map['habitQuestion'] = habitQuestion?.toJson();
    }
    if (answers != null) {
      map['answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class HabitQuestion {
  HabitQuestion({
    this.habitQuestionId,
    this.questionText,
  });

  HabitQuestion.fromJson(dynamic json) {
    habitQuestionId = json['habitQuestionId'];
    questionText = json['questionText'];
  }

  int? habitQuestionId;
  String? questionText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['habitQuestionId'] = habitQuestionId;
    map['questionText'] = questionText;
    return map;
  }
}

class HabitAnswer {
  HabitAnswer({
    this.habitQuestionAnsId,
    this.habitQuestionId,
    this.answerText,
    this.orderNo,
  });

  HabitAnswer.fromJson(dynamic json) {
    habitQuestionAnsId = json['habitQuestionAnsId'];
    habitQuestionId = json['habitQuestionId'];
    answerText = json['answerText'];
    orderNo = json['orderNo'];
  }

  int? habitQuestionAnsId;
  int? habitQuestionId;
  String? answerText;
  int? orderNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['habitQuestionAnsId'] = habitQuestionAnsId;
    map['habitQuestionId'] = habitQuestionId;
    map['answerText'] = answerText;
    map['orderNo'] = orderNo;
    return map;
  }
}
