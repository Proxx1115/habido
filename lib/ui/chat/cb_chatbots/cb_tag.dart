class CBTag {
  String? name;

  CBTag({
    this.name,
  });

  CBTag.fromJson(dynamic json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
