class DayModel {
  int? day;
  int? month;
  int? year;
  String? dayName;
  String? process;

  DayModel(int? day, String? dayName, String? process, {int? month, int? year}) {
    this.month = month ?? 1;
    this.year = year ?? 2022;
    this.day = day ?? 0;
    this.dayName = dayName ?? '';
    this.process = process ?? '';
  }
  DayModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayName = json['dayName'];
    process = json['process'];
  }
}

class CalendarRepo {
  List getAll() => dayList;
  List<DayModel> getDays() => dayList.map((map) => DayModel.fromJson(map)).map((item) => item).toList();
  List dayList = [
    {"day": 22, "dayName": "Лх", "process": "65.0"},
    {"day": 23, "dayName": "Пү", "process": "0.0"},
    {"day": 24, "dayName": "Ба", "process": "20.0"},
    {"day": 25, "dayName": "Бя", "process": "30.0"},
    {"day": 26, "dayName": "Ня", "process": "80.0"},
    {"day": 27, "dayName": "Да", "process": "90.0"},
    {"day": 28, "dayName": "Мя", "process": "100.0"},
  ];
}
