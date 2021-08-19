class Tags {
  String? name;

  Tags({
      this.name});

  Tags.fromJson(dynamic json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }

}