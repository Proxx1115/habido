class ContentTag {
  String? name;
  bool? isSelected; // Local param

  ContentTag({
    this.name,
    this.isSelected,
  });

  ContentTag.fromJson(dynamic json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
