import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';

class CBChatHistoryResponse extends BaseResponse {
  List<CBChatResponse>? chatList;

  CBChatHistoryResponse({this.chatList});

  CBChatHistoryResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      chatList = [];
      json['data'].forEach((v) {
        chatList?.add(CBChatResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (chatList != null) {
      map['data'] = chatList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
