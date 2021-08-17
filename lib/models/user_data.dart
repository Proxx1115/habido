import 'package:habido_app/models/base_response.dart';

class UserData extends BaseResponse {
  String? phone;
  String? firstName;
  String? lastName;
  String? email;
  String? birthDay;
  int? gender;
  String? photo;
  bool? isOnboardingDone;

  UserData({
    this.phone,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDay,
    this.gender,
    this.photo,
    this.isOnboardingDone,
  });

  UserData.fromJson(dynamic json) {
    parseBaseParams(json);

    phone = json['phone'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthDay = json['birthDay'];
    gender = json['gender'];
    photo = json['photo'];
    isOnboardingDone = json['isOnboardingDone'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['phone'] = phone;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['birthDay'] = birthDay;
    map['gender'] = gender;
    map['photo'] = photo;
    map['isOnboardingDone'] = isOnboardingDone;
    return map;
  }
}
