import 'base_response.dart';

class ChatbotsResponse extends BaseResponse {
  ChatbotsResponse({
    this.onBoardingCbId,
    this.assistantCbId,
    this.isAssistantChatDone,
  });

  ChatbotsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    onBoardingCbId = json['onBoardingCbId'];
    assistantCbId = json['assistantCbId'];
    isAssistantChatDone = json['isAssistantChatDone'];
  }

  int? onBoardingCbId;
  int? assistantCbId;
  bool? isAssistantChatDone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['onBoardingCbId'] = onBoardingCbId;
    map['assistantCbId'] = assistantCbId;
    map['isAssistantChatDone'] = isAssistantChatDone;
    return map;
  }
}
