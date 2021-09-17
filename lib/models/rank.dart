import 'package:habido_app/models/base_response.dart';

class Rank {
  int? rankId;
  String? name;
  String? body;
  String? conditionText;
  int? condition;
  String? photo;
  String? photoBase64;
  bool? hasPrevious;
  int? previousRankId;
  bool? hasNext;
  int? nextRankId;
  int? bonus;
  String? type;

  Rank(
      {this.rankId,
      this.name,
      this.body,
      this.conditionText,
      this.condition,
      this.photo,
      this.photoBase64,
      this.hasPrevious,
      this.previousRankId,
      this.hasNext,
      this.nextRankId,
      this.bonus,
      this.type});

  Rank.fromJson(dynamic json) {
    rankId = json['rankId'];
    name = json['name'];
    body = json['body'];
    conditionText = json['conditionText'];
    condition = json['condition'];
    photo = json['photo'];
    photoBase64 = json['photoBase64'];
    hasPrevious = json['hasPrevious'];
    previousRankId = json['previousRankId'];
    hasNext = json['hasNext'];
    nextRankId = json['nextRankId'];
    bonus = json['bonus'];
    type = json['type'];

    print('');
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['rankId'] = rankId;
    map['name'] = name;
    map['body'] = body;
    map['conditionText'] = conditionText;
    map['condition'] = condition;
    map['photo'] = photo;
    map['photoBase64'] = photoBase64;
    map['hasPrevious'] = hasPrevious;
    map['previousRankId'] = previousRankId;
    map['hasNext'] = hasNext;
    map['nextRankId'] = nextRankId;
    map['bonus'] = bonus;
    map['type'] = type;
    return map;
  }
}
