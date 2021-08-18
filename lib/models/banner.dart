class Banner {
  int? bannerId;
  String? name;
  String? link;
  String? linkBase64;
  String? deeplink;

  Banner({
      this.bannerId, 
      this.name, 
      this.link, 
      this.linkBase64, 
      this.deeplink});

  Banner.fromJson(dynamic json) {
    bannerId = json['bannerId'];
    name = json['name'];
    link = json['link'];
    linkBase64 = json['linkBase64'];
    deeplink = json['deeplink'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['bannerId'] = bannerId;
    map['name'] = name;
    map['link'] = link;
    map['linkBase64'] = linkBase64;
    map['deeplink'] = deeplink;
    return map;
  }

}