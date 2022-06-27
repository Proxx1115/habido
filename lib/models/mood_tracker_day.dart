import 'package:habido_app/utils/func.dart';

class MoodTrackerDay {
  String? data;
  double? point;

  MoodTrackerDay({this.data, this.point});

  MoodTrackerDay.fromJson(dynamic json) {
    data = json['data'];
    point = Func.toDouble(json['point']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['data'] = data;
    map['point'] = point;

    return map;
  }
}
