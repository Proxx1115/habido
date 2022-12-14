class HabitToolContent {
  bool? emoji;
  bool? camera;
  String? music;
  String? animation;
  bool? question;
  bool? isFeeling;

  HabitToolContent({this.emoji, this.camera, this.music, this.animation, this.question, this.isFeeling});

  HabitToolContent.fromJson(dynamic json) {
    emoji = json['emoji'];
    camera = json['camera'];
    music = json['music'];
    animation = json['animation'];
    question = json['question'];
    isFeeling = json['isFeeling'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['emoji'] = emoji;
    map['camera'] = camera;
    map['music'] = music;
    map['animation'] = animation;
    map['question'] = question;
    map['isFeeling'] = isFeeling;
    return map;
  }
}
