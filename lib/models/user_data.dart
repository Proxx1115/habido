import 'package:habido_app/models/base_response.dart';

class UserData extends BaseResponse {
  int? userId;
  int? habitCategoryId;
  String? phone;
  String? firstName;
  String? lastName;
  String? email;
  String? birthDay;
  String? gender;
  String? photo;
  bool? isOnboardingDone;
  bool? isOnboardingDone2;
  bool? hasOAuth2;
  int? rankId; // 1-6
  String? rankPhoto;
  String? rankName;
  String? rankBody;
  String? address;
  String? employment;
  int? oAuth2SkipCount;

  UserData(
      {this.userId,
      this.habitCategoryId,
      this.phone,
      this.firstName,
      this.lastName,
      this.email,
      this.birthDay,
      this.gender,
      this.photo,
      this.isOnboardingDone,
      this.isOnboardingDone2,
      this.rankId,
      this.rankPhoto,
      this.rankName,
      this.rankBody,
      this.address,
      this.employment,
      this.hasOAuth2,
      this.oAuth2SkipCount});

  UserData.fromJson(dynamic json) {
    parseBaseParams(json);

    userId = json['userId'];
    habitCategoryId = json['habitCategoryId'];
    phone = json['phone'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthDay = json['birthDay'];
    gender = json['gender'];
    photo = json['photo'];
    isOnboardingDone = json['isOnboardingDone'];
    isOnboardingDone2 = json['isOnboardingDone2'];
    rankId = json['rankId'];
    rankPhoto = json['rankPhoto'];
    rankName = json['rankName'];
    rankBody = json['rankBody'];
    address = json['address'];
    employment = json['employment'];
    hasOAuth2 = json['hasOAuth2'];
    oAuth2SkipCount = json['oAuth2SkipCount'];
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
    map['isOnboardingDone2'] = isOnboardingDone2;
    map['address'] = address;
    map['employment'] = employment;
    map['hasOAuth2'] = hasOAuth2;
    map['oAuth2SkipCount'] = oAuth2SkipCount;

    return map;
  }
}
