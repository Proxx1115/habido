import 'package:habido_app/utils/localization/localization.dart';

class Plan {
  int? day;
  bool? isSelected; // Local param

  Plan({this.day});

  Plan.fromJson(dynamic json) {
    day = json['day'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['day'] = day;
    map['isSelected'] = isSelected;
    return map;
  }
}

