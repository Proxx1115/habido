class UpdateProfilePictureRequest {
  UpdateProfilePictureRequest({
    this.photoBase64,
  });

  UpdateProfilePictureRequest.fromJson(dynamic json) {
    photoBase64 = json['photoBase64'];
  }

  String? photoBase64;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['photoBase64'] = photoBase64;
    return map;
  }
}
