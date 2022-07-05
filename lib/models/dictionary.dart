import 'package:habido_app/models/base_response.dart';

class DictData extends BaseResponse {
  String? val;
  String? txt;
  int? orderNo;

  DictData({this.val, this.txt, this.orderNo});

  DictData.fromJson(dynamic json) {
    parseBaseParams(json);

    val = json['val'];
    txt = json['txt'];
    orderNo = json['orderNo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['val'] = val;
    map['txt'] = txt;
    map['orderNo'] = orderNo;
    return map;
  }
}
