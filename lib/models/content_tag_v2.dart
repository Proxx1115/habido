import 'package:habido_app/models/base_response.dart';

class ContentTagV2 extends BaseResponse {
  String? name;
  bool? isSelected; // Local param

  ContentTagV2({
    this.name,
    this.isSelected,
  });

  ContentTagV2.fromJson(dynamic json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
