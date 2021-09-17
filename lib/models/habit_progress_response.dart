import 'package:habido_app/models/base_response.dart';
import 'base_response.dart';
import 'habit_progress.dart';
import 'rank.dart';

class HabitProgressResponse extends BaseResponse {
  String? title;
  String? body;
  Rank? rank;

  HabitProgressResponse({this.rank, this.title, this.body});

  HabitProgressResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    title = json['title'];
    body = json['body'];
    rank = json['rank'] != null ? Rank.fromJson(json['rank']) : null;

    // test
    // rank = Rank()
    //   ..name = 'Beginner'
    //   ..photo = 'https://habido-test.s3-ap-southeast-1.amazonaws.com/rank/b75179dc-202c-4a42-a2d9-d6fc044cc1b3.png';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    map['rank'] = rank;
    return map;
  }
}
