class UpdateUserDataRequest {
  UpdateUserDataRequest(
      {this.firstName,
      this.lastName,
      this.birthday,
      this.userGender,
      this.employment,
      this.address,
      this.email,
      this.phone});

  UpdateUserDataRequest.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthday = json['birthday'];
    userGender = json['userGender'];
    employment = json['employment'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
  }

  String? firstName;
  String? lastName;
  String? birthday;
  String? userGender;
  String? employment;
  String? address;
  String? email;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['birthday'] = birthday;
    map['userGender'] = userGender;
    map['employment'] = employment;
    map['address'] = address;
    map['email'] = email;
    map['phone'] = phone;

    return map;
  }
}
