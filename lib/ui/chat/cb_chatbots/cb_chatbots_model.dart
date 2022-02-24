import 'package:habido_app/models/base_response.dart';

class CBChatBotsModel extends BaseResponse {
  int? cbId;
  String? name;
  String? cbType;

  CBChatBotsModel({
    this.cbId,
    this.name,
    this.cbType,
  });

  CBChatBotsModel.fromJson(dynamic json) {
    cbId = json['cbId'];
    name = json['name'];
    cbType = json['cbType'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cbId'] = cbId;
    map['name'] = name;
    map['cbType'] = cbType;
    return map;
  }
}
