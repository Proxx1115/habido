class SignUpVerifyCodeRequest {
  SignUpVerifyCodeRequest({
      this.userId, 
      this.code,});

  SignUpVerifyCodeRequest.fromJson(dynamic json) {
    userId = json['userId'];
    code = json['code'];
  }
  int? userId;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['code'] = code;
    return map;
  }

}