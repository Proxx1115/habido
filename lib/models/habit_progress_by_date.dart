import 'habit_progress.dart';

class HabitProgressesByDate {
  String? date;
  List<HabitProgress>? progressList;

  HabitProgressesByDate({this.date, this.progressList});

  HabitProgressesByDate.fromJson(dynamic json) {
    date = json['date'];
    if (json['progresses'] != null) {
      progressList = [];
      json['progresses'].forEach((v) {
        progressList?.add(HabitProgress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['date'] = date;
    if (progressList != null) {
      map['progresses'] = progressList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
