import 'package:habido_app/utils/localization/localization.dart';

class Plan {
  int? day;
  String? photo;
  bool? isSelected; // Local param

  Plan({this.day});

  Plan.fromJson(dynamic json) {
    day = json['day'];
    photo = json['photo'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['day'] = day;
    map['photo'] = photo;
    map['isSelected'] = isSelected;
    return map;
  }
}
