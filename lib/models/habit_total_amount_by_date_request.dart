import 'package:habido_app/models/base_request.dart';

class HabitTotalAmountByDateRequest extends BaseRequest {
  int? userHabitId;
  String? startDate;
  String? lastDate;

  HabitTotalAmountByDateRequest({
    this.userHabitId,
    this.startDate,
    this.lastDate,
  });

  HabitTotalAmountByDateRequest.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    startDate = json['startDate'];
    lastDate = json['lastDate'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['startDate'] = startDate;
    map['lastDate'] = lastDate;
    return map;
  }
}
