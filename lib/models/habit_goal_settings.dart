import 'habit_tool_content.dart';

class HabitGoalSettings {
  int? goalTypeId;
  String? goalName; // Feeling ued utga baihgui, Satisfaction
  int? goalMin;
  int? goalMax;
  int? goalStep;
  bool? goalIsExtendable; // Хугацаа нэмж сунгах боломжтой эсэх
  bool? goalValueSelectable; // Slider харуулж утга сонгох боломжтой эсэх

  // Дадал биелүүлэх tools
  String? toolType; // Minute, Hour, Count, Feeling (emoji), Satisfaction, Amount (Finance),
  // Хасагдсан - Music, Animation, Camera
  String? toolUnit; // Нэгж - минут, цаг, аяга, 'emoji - тоо', '₮',
  HabitToolContent? toolContent; // ;-аар тусгаарлагдсан линк ирнэ

  HabitGoalSettings({
    this.goalTypeId,
    this.goalName,
    this.goalMin,
    this.goalMax,
    this.goalStep,
    this.goalIsExtendable,
    this.goalValueSelectable,
    this.toolType,
    this.toolUnit,
    this.toolContent,
  });

  HabitGoalSettings.fromJson(dynamic json) {
    goalTypeId = json['goalTypeId'];
    goalName = json['goalName'];
    goalMin = json['goalMin'];
    goalMax = json['goalMax'];
    goalStep = json['goalStep'] ?? 1;
    goalIsExtendable = json['goalIsExtendable'];
    goalValueSelectable = json['goalValueSelectable'];
    toolType = json['toolType'];
    toolUnit = json['toolUnit'];
    toolContent = json['toolContent'] != null ? HabitToolContent.fromJson(json['toolContent']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['goalTypeId'] = goalTypeId;
    map['goalName'] = goalName;
    map['goalMin'] = goalMin;
    map['goalMax'] = goalMax;
    map['goalStep'] = goalStep;
    map['goalIsExtendable'] = goalIsExtendable;
    map['goalValueSelectable'] = goalValueSelectable;
    map['toolType'] = toolType;
    map['toolUnit'] = toolUnit;
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
