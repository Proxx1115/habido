class CBPoster {
  int? posterId;
  String? link;

  CBPoster({
    this.posterId,
    this.link,
  });

  CBPoster.fromJson(dynamic json) {
    posterId = json['posterId'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['posterId'] = posterId;
    map['link'] = link;
    return map;
  }
}
