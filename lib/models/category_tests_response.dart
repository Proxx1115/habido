// import 'package:habido_app/models/base_response.dart';
// import 'package:habido_app/models/psy_tests_response.dart';
//
// import 'content.dart';
// import 'psy_test.dart';
//
// class CategoryTestsResponse extends BaseResponse {
//   Content? content;
//   List<PsyTest>? psyTestList;
//
//   CategoryTestsResponse({this.content, this.psyTestList});
//
//   CategoryTestsResponse.fromJson(dynamic json) {
//     parseBaseParams(json);
//     content = json['content'] != null ? Content.fromJson(json['content']) : null;
//     if (json['tests'] != null) {
//       psyTestList = [];
//       json['tests'].forEach((v) {
//         print('test');
//         // psyTestList?.add(PsyTestsResponse.fromJson(v));
//         print('test');
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     if (content != null) {
//       map['content'] = content?.toJson();
//     }
//     if (psyTestList != null) {
//       map['tests'] = psyTestList?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }
