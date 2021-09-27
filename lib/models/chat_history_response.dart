import 'package:habido_app/models/base_response.dart';
import 'base_response.dart';
import 'chat_response.dart';

class ChatHistoryResponse extends BaseResponse {
  List<ChatResponse>? chatList;

  ChatHistoryResponse({this.chatList});

  ChatHistoryResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      chatList = [];
      json['data'].forEach((v) {
        chatList?.add(ChatResponse.fromJson(v));
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
