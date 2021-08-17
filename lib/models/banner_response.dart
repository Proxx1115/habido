import 'base_response.dart';

// class BannerResponse extends BaseResponse {
//   List<CustomBanner> bannerList;
//
//   BannerResponse({this.bannerList});
//
//   BannerResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       code = json[ResponseHelper.code];
//       message = json[ResponseHelper.message];
//
//       bannerList = List<CustomBanner>();
//       if (json[ResponseHelper.data] != null) {
//         json[ResponseHelper.data].forEach((v) {
//           bannerList.add(CustomBanner.fromJson(v));
//         });
//       }
//
//       print('test');
//     } catch (e) {
//       code = ResponseCode.Failed;
//       message = AppText.noData;
//       print(e);
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     return data;
//   }
// }
//
// class CustomBanner {
//   String name;
//   String link;
//   String deeplink;
//
//   CustomBanner({this.name, this.link, this.deeplink});
//
//   CustomBanner.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     link = json['link'];
//     deeplink = json['deeplink'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['link'] = this.link;
//     data['deeplink'] = this.deeplink;
//     return data;
//   }
// }
