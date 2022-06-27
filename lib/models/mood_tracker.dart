class MoodTracker {
  String? imageUrl;
  String? mood;
  String? dateTime;

  MoodTracker({
    this.imageUrl,
    this.mood,
    this.dateTime,
  });

  MoodTracker.fromJson(dynamic json) {
    imageUrl = json['imageUrl'];
    mood = json['mood'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['imageUrl'] = imageUrl;
    map['mood'] = mood;
    map['dateTime'] = dateTime;
    return map;
  }
}
