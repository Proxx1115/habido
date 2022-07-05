import 'package:habido_app/models/get_dict_list_request.dart';
import 'package:habido_app/models/get_dicts_list_response.dart';

class GetDictRequest {
  DictRequestModel? dict;
  String? filter;

  GetDictRequest({this.dict, this.filter});

  GetDictRequest.fromJson(Map<String, dynamic> json) {
    dict = json['dict'];
    filter = json['filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dict'] = this.dict;
    data['filter'] = this.filter;
    return data;
  }
}
