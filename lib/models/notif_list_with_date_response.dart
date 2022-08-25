import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/notif_list_with_date.dart';

class NotifListWithDateResponse extends BaseResponse {
  List<NotifListWithDate>? notifListWithDate;

  NotifListWithDateResponse({
    this.notifListWithDate,
  });

  NotifListWithDateResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      notifListWithDate = [];
      json['data'].forEach((v) {
        notifListWithDate?.add(NotifListWithDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (notifListWithDate != null) {
      map['data'] = notifListWithDate?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
