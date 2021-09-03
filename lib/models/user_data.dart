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
  int? rankId; // 1-6
  String? rankPhoto;
  String? rankName;
  String? rankBody;

  UserData({
    this.phone,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDay,
    this.gender,
    this.photo,
    this.isOnboardingDone,
    this.rankId,
    this.rankPhoto,
    this.rankName,
    this.rankBody,
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
    rankId = json['rankId'];
    rankPhoto = json['rankPhoto'];
    rankName = json['rankName'];
    rankBody = json['rankBody'];
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
