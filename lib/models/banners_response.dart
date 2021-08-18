import 'banner.dart';
import 'base_response.dart';

class BannersResponse extends BaseResponse {
  List<Banner>? bannerList;

  BannersResponse({this.bannerList});

  BannersResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['termsOfService'] != null) {
      bannerList = [];
      json['termsOfService'].forEach((v) {
        bannerList?.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (bannerList != null) {
      map['termsOfService'] = bannerList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
