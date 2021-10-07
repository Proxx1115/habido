class MonthlyAchievement {
  int? monthlyPercentage;
  String? monthlyAchievement;
  String? monthlyTotalCompletedHabits;

  MonthlyAchievement({
      this.monthlyPercentage, 
      this.monthlyAchievement, 
      this.monthlyTotalCompletedHabits});

  MonthlyAchievement.fromJson(dynamic json) {
    monthlyPercentage = json['monthlyPercentage'];
    monthlyAchievement = json['monthlyAchievement'];
    monthlyTotalCompletedHabits = json['monthlyTotalCompletedHabits'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['monthlyPercentage'] = monthlyPercentage;
    map['monthlyAchievement'] = monthlyAchievement;
    map['monthlyTotalCompletedHabits'] = monthlyTotalCompletedHabits;
    return map;
  }

}