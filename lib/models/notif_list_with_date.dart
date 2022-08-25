import 'notif.dart';


class NotifListWithDate{
  String? date;
  List<Notif>? notifList;

  NotifListWithDate({
    this.date,
    this.notifList,
  });

  NotifListWithDate.fromJson(dynamic json) {
    // parseBaseParams(json)

    date = json['date'];
    if (json['dataNotifs'] != null) {
      notifList = [];
      json['dataNotifs'].forEach((v) {
        notifList?.add(Notif.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['date'] = date;
    if (notifList != null) {
      map['dataNotifs'] = notifList?.map((v) => v.toJson()).toList();
    }
    
    return map;
  }

}