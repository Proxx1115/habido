import 'custom_banner.dart';
import 'base_response.dart';

class CustomBannersResponse extends BaseResponse {
  List<CustomBanner>? bannerList;

  CustomBannersResponse({this.bannerList});

  CustomBannersResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      bannerList = [];
      json['data'].forEach((v) {
        bannerList?.add(CustomBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (bannerList != null) {
      map['data'] = bannerList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
