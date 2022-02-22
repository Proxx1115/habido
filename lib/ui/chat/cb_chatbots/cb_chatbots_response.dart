import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chatbots_model.dart';

class CBChatBotsResponse extends BaseResponse {
  List<CBChatBotsModel>? chatbots;

  CBChatBotsResponse({
    this.chatbots,
  });

  CBChatBotsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      chatbots = [];
      json['data'].forEach((v) {
        if (v != null) chatbots?.add(CBChatBotsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (chatbots != null) {
      map['data'] = chatbots?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
