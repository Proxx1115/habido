class MoodTrackerReason {
  String? reasonName;
  int? count;

  MoodTrackerReason({
    this.reasonName,
    this.count,
  });

  MoodTrackerReason.fromJson(dynamic json) {
    reasonName = json['reasonName'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['reasonName'] = reasonName;
    map['count'] = count;

    return map;
  }
}
