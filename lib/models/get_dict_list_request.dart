import 'package:habido_app/models/base_request.dart';

class GetDictListRequest extends BaseRequest {
  List<DictRequestModel>? dicts;

  GetDictListRequest({this.dicts});

  GetDictListRequest.fromJson(Map<String, dynamic> json) {
    if (json['dicts'] != null) {
      dicts = <DictRequestModel>[];
      json['dicts'].forEach((v) {
        dicts!.add(new DictRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dicts != null) {
      data['dicts'] = this.dicts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DictRequestModel {
  String? code;
  String? type;

  DictRequestModel({this.code});

  DictRequestModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    return data;
  }
}
