import 'package:habido_app/models/base_response.dart';
import 'notif.dart';

class NotifListResponse extends BaseResponse {
  List<Notif>? notifList;

  NotifListResponse({
    this.notifList,
  });

  NotifListResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      notifList = [];
      json['data'].forEach((v) {
        notifList?.add(Notif.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (notifList != null) {
      map['data'] = notifList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
