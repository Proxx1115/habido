import 'package:habido_app/models/base_request.dart';

class SendFeedbackRequest extends BaseRequest {
  SendFeedbackRequest({
    this.feedBackId,
    this.feedBackCatId,
    this.userId,
    this.phone,
    this.text,
  });

  SendFeedbackRequest.fromJson(dynamic json) {
    feedBackId = json['feedBackId'];
    feedBackCatId = json['feedBackCatId'];
    userId = json['userId'];
    phone = json['phone'];
    text = json['text'];
  }

  int? feedBackId;
  int? feedBackCatId;
  int? userId;
  String? phone;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feedBackId'] = feedBackId;
    map['feedBackCatId'] = feedBackCatId;
    map['userId'] = userId;
    map['phone'] = phone;
    map['text'] = text;

    return map;
  }
}
