class HabitGoalSettings {
  int? goalTypeId;
  String? goalName; // Feeling ued utga baihgui
  int? goalMin;
  int? goalMax;
  String? toolType; // Minute, Hour, Count, Feeling (emoji), Satisfaction, Amount (Finance), Music, Animation,
  String? toolContent; // Минут, Цаг, Аяга, 'emoji', 'camera', '₮', 'music link', 'Tree animation, ... animation',

  HabitGoalSettings({this.goalTypeId, this.goalName, this.goalMin, this.goalMax, this.toolType, this.toolContent});

  HabitGoalSettings.fromJson(dynamic json) {
    goalTypeId = json['goalTypeId'];
    goalName = json['goalName'];
    goalMin = json['goalMin'];
    goalMax = json['goalMax'];
    toolType = json['toolType'];
    toolContent = json['toolContent'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['goalTypeId'] = goalTypeId;
    map['goalName'] = goalName;
    map['goalMin'] = goalMin;
    map['goalMax'] = goalMax;
    map['toolType'] = toolType;
    map['toolContent'] = toolContent;
    return map;
  }
}

//1	Хугацаа	0	60	Minute	минут
//2	Хэмжээ	0	12	Count	Аяга
//3	Хугацаа	0	96	Hour	цаг
//4	Feeling	1	5	Feeling	emoji
//5	Satisfaction	1	10	Satisfaction	camera
//6	Төгрөг	0	1000000000	Amount	₮
//7	Music	0	1000000000	Music	https://www.youtube.com/watch?v=0tdnAH58rEw=AniMelody%E2%80%93AnimeMusic
//8	Animation	0	1000000000	Animation	Tree animation
//10	Creativity	0	100	Animation	Creativity
//9	Animation	0	100	Animation	Breathing animation

// class HabitGoalSettings {
//   // Үндсэн зорилго
//   int? goalTypeId;
//   String? goalName; // Feeling ued utga baihgui
//   int? goalMin;
//   int? goalMax;
//
//   // Дадал биелүүлэх tools
//   int? toolType; // Minute, Hour, Count, Feeling (emoji), Satisfaction, Amount (Finance), Music, Animation,
//   int? toolContent; // Минут, Цаг, Аяга, 'emoji', 'camera', '₮', 'music link', 'Tree animation, ... animation',
// }
