import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/utils/func.dart';
import 'base_response.dart';

class DateIntervalProgressResponse extends BaseResponse {
  List<DateProgress>? datesProgress;

  DateIntervalProgressResponse({this.datesProgress});

  DateIntervalProgressResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      datesProgress = [];
      json['data'].forEach((v) {
        datesProgress?.add(DateProgress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    return map;
  }
}

class DateProgress {
  String? date;
  double? percentage;

  DateProgress({this.date, this.percentage});

  DateProgress.fromJson(dynamic json) {
    date = json["date"];
    percentage = Func.toDouble(json['percentage']);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    return map;
  }
}
