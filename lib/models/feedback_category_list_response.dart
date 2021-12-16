import 'package:habido_app/models/base_request.dart';

class FeedBackCategoryListResponse extends BaseRequest {
  FeedBackCategoryListResponse({
    this.feedBackCatId,
    this.name,
  });

  FeedBackCategoryListResponse.fromJson(dynamic json) {
    feedBackCatId = json['feedBackCatId'];
    name = json['name'];
  }

  int? feedBackCatId;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feedBackCatId'] = feedBackCatId;
    map['name'] = name;

    return map;
  }
}