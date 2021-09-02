class AllTimeAchievement {
  int? allTimePercentage;
  String? allTimeAchievement;
  int? allTimeTotalCompletedHabits;

  AllTimeAchievement({
      this.allTimePercentage, 
      this.allTimeAchievement, 
      this.allTimeTotalCompletedHabits});

  AllTimeAchievement.fromJson(dynamic json) {
    allTimePercentage = json['allTimePercentage'];
    allTimeAchievement = json['allTimeAchievement'];
    allTimeTotalCompletedHabits = json['allTimeTotalCompletedHabits'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['allTimePercentage'] = allTimePercentage;
    map['allTimeAchievement'] = allTimeAchievement;
    map['allTimeTotalCompletedHabits'] = allTimeTotalCompletedHabits;
    return map;
  }

}