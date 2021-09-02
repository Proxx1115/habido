class Notif {
  int? notifId;
  String? title;
  String? body;
  bool? viewed;
  String? createdAt;

  Notif({this.notifId, this.title, this.body, this.viewed, this.createdAt});

  Notif.fromJson(dynamic json) {
    notifId = json['notifId'];
    title = json['title'];
    body = json['body'];
    viewed = json['viewed'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['notifId'] = notifId;
    map['title'] = title;
    map['body'] = body;
    map['viewed'] = viewed;
    map['createdAt'] = createdAt;
    return map;
  }
}
