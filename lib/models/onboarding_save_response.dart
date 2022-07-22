import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/habit_template.dart';
import 'package:habido_app/utils/func.dart';

import 'habit.dart';

class OnBoardingSaveResponse extends BaseResponse {
  String? question;
  String? tip;
  HabitTemplate? template;

  OnBoardingSaveResponse({
    this.question,
    this.tip,
  });

  OnBoardingSaveResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    question = json['question'];
    tip = json['tip'];
    template = json['template'] != null ? HabitTemplate.fromJson(json['template']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['question'] = question;
    map['tip'] = tip;
    map['template'] = template;
    return map;
  }
}
