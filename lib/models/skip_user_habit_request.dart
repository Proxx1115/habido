import 'package:habido_app/models/base_request.dart';

class SkipUserHabitRequest extends BaseRequest {
  SkipUserHabitRequest({
    this.userHabitId,
    this.skipDay,
  });

  SkipUserHabitRequest.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    skipDay = json['skipDay'];
  }

  int? userHabitId;
  String? skipDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['skipDay'] = skipDay;
    return map;
  }
}
