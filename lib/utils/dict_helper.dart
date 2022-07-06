import 'package:habido_app/models/dictionary.dart';
import 'package:habido_app/models/get_dict_list_request.dart';
import 'package:habido_app/models/get_dicts_list_response.dart';

class DictHelper {
  static DictRequestModel userAddress =
      DictRequestModel(code: DictCode.address);
  static DictRequestModel userEmplo =
      DictRequestModel(code: DictCode.employment);

  static List<DictData>? getDictListByCode(String code, List<Dict> dictList) {
    for (var element in dictList) {
      if (code == element.dictCode) {
        return element.items;
      }
    }
    return null;
  }
}

class DictCode {
  static const String address = 'UserAddress';
  static const String employment = 'UserEmployment';
}
