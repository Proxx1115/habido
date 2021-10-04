import 'package:habido_app/models/base_response.dart';
import 'base_response.dart';

class HabitCalendarResponse extends BaseResponse {
  List<HabitCalendarEvent>? calendarEventList;

  HabitCalendarResponse({this.calendarEventList});

  HabitCalendarResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      calendarEventList = [];
      json['data'].forEach((v) {
        calendarEventList?.add(HabitCalendarEvent.fromJson(v));
      });
    }

    // calendarEventList = [
    //   HabitCalendarEvent()
    //     ..date = '2021-10-04'
    //     ..colors = [
    //       '#FA6C51',
    //       '#FA6C51',
    //     ],
    //   HabitCalendarEvent()
    //     ..date = '2021-10-05'
    //     ..colors = [
    //       '#FA6C51',
    //       '#FA6C51',
    //       '#FA6C51',
    //     ],
    //   HabitCalendarEvent()
    //     ..date = '2021-10-06'
    //     ..colors = [
    //       '#FA6C51',
    //       '#FA6C51',
    //       '#FA6C51',
    //       '#FA6C51',
    //     ],
    //   HabitCalendarEvent()
    //     ..date = '2021-10-07'
    //     ..colors = [
    //       '#FA6C51',
    //     ],
    // ];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    return map;
  }
}

class HabitCalendarEvent {
  String? date;
  List<String>? colors;

  HabitCalendarEvent({this.date, this.colors});

  HabitCalendarEvent.fromJson(dynamic json) {
    date = json["date"];
    if (json['colors'] != null) {
      colors = [];
      json['colors'].forEach((v) {
        colors?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    return map;
  }
}
