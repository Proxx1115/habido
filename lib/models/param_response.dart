import 'base_response.dart';

class ParamResponse extends BaseResponse {
  List<TermsOfService>? termsOfService;
  String? iosVersion;
  String? androidVersion;

  ParamResponse({
    this.termsOfService,
    this.iosVersion,
    this.androidVersion,
  });

  ParamResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['termsOfService'] != null) {
      termsOfService = [];
      json['termsOfService'].forEach((v) {
        termsOfService?.add(TermsOfService.fromJson(v));
      });
    }
    iosVersion = json['iosVersion'];
    androidVersion = json['androidVersion'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (termsOfService != null) {
      map['termsOfService'] = termsOfService?.map((v) => v.toJson()).toList();
    }
    map['iosVersion'] = iosVersion;
    map['androidVersion'] = androidVersion;
    return map;
  }
}

class TermsOfService {
  String? title;
  String? body;

  TermsOfService({this.title, this.body});

  TermsOfService.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    return map;
  }
}
