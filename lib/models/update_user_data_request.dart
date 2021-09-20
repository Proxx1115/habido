class UpdateUserDataRequest {
  UpdateUserDataRequest({
    this.firstName,
    this.lastName,
    this.birthday,
    this.userGender,
  });

  UpdateUserDataRequest.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthday = json['birthday'];
    userGender = json['userGender'];
  }

  String? firstName;
  String? lastName;
  String? birthday;
  String? userGender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['birthday'] = birthday;
    map['userGender'] = userGender;
    return map;
  }
}
