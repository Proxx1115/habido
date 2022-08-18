class LineModel {
  int? day;
  int? month;
  int? year;
  int? status;
  String? process;

  LineModel(int? day, int? status, String? process, int? month, int? year) {
    this.month = month ?? 1;
    this.year = year ?? 2022;
    this.day = day ?? 0;
    this.status = status ?? 0;
    this.process = process ?? '';
  }
  LineModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    status = json['status'];
    process = json['process'];
  }
}

class LineRepo {
  List getAll() => dayList;
  List<LineModel> getDays() => dayList.map((map) => LineModel.fromJson(map)).map((item) => item).toList();
  List dayList = [
    {"day": 22, "status": 1, "process": "65.0"},
    {"day": 23, "status": 10, "process": "0.0"},
    {"day": 24, "status": 5, "process": "20.0"},
    {"day": 25, "status": 7, "process": "30.0"},
    {"day": 26, "status": 6, "process": "80.0"},
    {"day": 27, "status": 9, "process": "90.0"},
    {"day": 28, "status": 10, "process": "100.0"},
  ];
}
