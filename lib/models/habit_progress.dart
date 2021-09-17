class HabitProgress {
  int? progressId;
  int? planId;
  String? value;
  String? note;
  String? photo;
  int? progressCatId;
  String? progressCatName;
  int? answerId;
  int? userHabitId;

  HabitProgress(
      {this.progressId,
      this.planId,
      this.value,
      this.note,
      this.photo,
      this.progressCatId,
      this.answerId,
      this.userHabitId});

  HabitProgress.fromJson(dynamic json) {
    progressId = json['progressId'];
    planId = json['planId'];
    value = json['value'];
    note = json['note'];
    photo = json['photo'];
    progressCatId = json['progressCatId'];
    progressCatName = json['progressCatName'];
    answerId = json['answerId'];
    userHabitId = json['userHabitId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['progressId'] = progressId;
    map['planId'] = planId;
    map['value'] = value;
    map['note'] = note;
    map['photo'] = photo;
    map['progressCatId'] = progressCatId;
    map['progressCatName'] = progressCatName;
    map['answerId'] = answerId;
    map['userHabitId'] = userHabitId;
    return map;
  }
}
