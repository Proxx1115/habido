import 'package:habido_app/models/base_request.dart';

class SendFeedbackRequest extends BaseRequest {
  SendFeedbackRequest({
    this.feedBackId,
    this.userId,
    this.phone,
    this.text,
  });

  SendFeedbackRequest.fromJson(dynamic json) {
    feedBackId = json['feedBackId'];
    userId = json['userId'];
    phone = json['phone'];
    text = json['text'];
  }

  int? feedBackId;
  int? userId;
  String? phone;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feedBackId'] = feedBackId;
    map['userId'] = userId;
    map['phone'] = phone;
    map['text'] = text;

    return map;
  }
}
