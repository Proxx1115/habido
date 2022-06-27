import 'package:habido_app/models/base_response.dart';

class ContentTagV2 {
  String? name;
  String? filterValue;
  bool? isSelected; // Local param

  ContentTagV2({
    this.name,
    this.filterValue,
    this.isSelected,
  });

  ContentTagV2.fromJson(dynamic json) {
    name = json['name'];
    filterValue = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = filterValue;
    return map;
  }
}
