import 'package:habido_app/models/base_response.dart';
import 'base_response.dart';
import 'content.dart';

class HabitCalendarResponse extends BaseResponse {
  List<String>? dateList;

  HabitCalendarResponse({this.dateList});

  HabitCalendarResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      dateList = [];
      json['data'].forEach((v) {
        dateList?.add(v);
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    // if (dateList != null) {
    //   map['data'] = dateList?.map((v) => v.toJson()).toList();
    // }

    return map;
  }
}
