import 'habit_progress.dart';

class HabitProgressListWithDate {
  HabitProgressListWithDate({
    this.date,
    this.progresses,
  });

  HabitProgressListWithDate.fromJson(dynamic json) {
    date = json['date'];
    if (json['progresses'] != null) {
      progresses = [];
      json['progresses'].forEach((v) {
        progresses?.add(HabitProgress.fromJson(v));
      });
    }

    isExpanded = false;
  }

  String? date;
  List<HabitProgress>? progresses;

  bool? isExpanded; // Local param

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    if (progresses != null) {
      map['progresses'] = progresses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
