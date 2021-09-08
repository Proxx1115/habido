class Notif {
  int? notifId;
  String? notifType;
  String? title;
  String? body;
  String? photo;
  String? color;
  bool? viewed;
  String? createdAt;

  Notif({
    this.notifId,
    this.notifType,
    this.title,
    this.body,
    this.photo,
    this.color,
    this.viewed,
    this.createdAt,
  });

  Notif.fromJson(dynamic json) {
    notifId = json['notifId'];
    notifType = json['notifType'];
    title = json['title'];
    body = json['body'];
    photo = json['photo'];
    color = json['color'];
    viewed = json['viewed'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['notifId'] = notifId;
    map['notifType'] = notifType;
    map['title'] = title;
    map['body'] = body;
    map['photo'] = photo;
    map['color'] = color;
    map['viewed'] = viewed;
    map['createdAt'] = createdAt;
    return map;
  }
}
