import 'package:habido_app/models/base_request.dart';

class AddOauth extends BaseRequest {
  String? email;
  String? type;

  AddOauth({this.email, this.type});

  AddOauth.fromJson(dynamic json) {
    email = json["email"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = email;
    map["type"] = type;
    return map;
  }
}
