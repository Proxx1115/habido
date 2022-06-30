import 'package:habido_app/models/tip.dart';
import 'package:habido_app/models/base_response.dart';

class TipCategory extends BaseResponse {
  int? tipCategoryId;
  String? categoryName;
  String? bgColor;
  String? icon;
  bool? featured;
  List<Tip>? tips;

  TipCategory({
    this.tipCategoryId,
    this.categoryName,
    this.bgColor,
    this.icon,
    this.featured,
    this.tips,
  });

  TipCategory.fromJson(dynamic json) {
    parseBaseParams(json);

    tipCategoryId = json['tipCategoryId'];
    categoryName = json['categoryName'];
    bgColor = json['bgColor'];
    icon = json['icon'];
    featured = json['featured'];
    if (json['tips'] != null) {
      tips = [];
      json['tips'].forEach((v) {
        tips?.add(Tip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tipCategoryId'] = tipCategoryId;
    map['categoryName'] = categoryName;
    map['bgColor'] = bgColor;
    map['icon'] = icon;
    map['featured'] = featured;
    if (tips != null) {
      map['tips'] = tips?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
