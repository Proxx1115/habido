import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chatbots_model.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chatbots_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option_request.dart';
import 'package:habido_app/ui/chat/chat_screen_new.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:rxdart/subjects.dart';

class ChatScreenNewBloc {
  final reloadSubject = BehaviorSubject<bool>();
  final loadingSubject = BehaviorSubject<bool>();

  List<CBChatResponse> chatList = [];

  dismiss() {
    reloadSubject.close();
    loadingSubject.close();
  }

  cbChatbots() async {
    CBChatBotsResponse res = await ApiManager.cbChatbots();
    if (res.code == ResponseCode.Success) {
      List<CBChatBotsModel> chatbots = res.data;
      print('success' + chatbots.length.toString());
    } else {
      print("failed");
    }
  }

  cbFirstChat() async {
    var request = ChatRequest()..cbId = 13;
    var res = await ApiManager.cbFirstChat(request);
    if (res.code == ResponseCode.Success) {
      chatList.add(res);
      if (res.isEnd == false &&
          res.hasOption == false &&
          res.continueMsgId != null) {
        cbContinueChat(res.continueMsgId!);
      } else
        reloadSubject.add(true);
    } else {
      print('cbFirstChat failed');
    }
  }

  cbContinueChat(int msgId) async {
    var res = await ApiManager.cbContinueChat(msgId);
    if (res.code == ResponseCode.Success) {
      chatList.add(res);
      if (res.isEnd == false &&
          res.hasOption == false &&
          res.continueMsgId != null) {
        cbContinueChat(res.continueMsgId!);
      } else
        reloadSubject.add(true);
    } else {
      print('cbContinueChat failed');
    }
  }

  cbMsgOption(CBMsgOption option) async {
    for (int i = 0; i < chatList.last.cbMsgOptions!.length; i++) {
      if (chatList.last.cbMsgOptions![i].optionId == option.optionId) {
        CBMsgOption temp = chatList.last.cbMsgOptions![i];
        chatList.last.cbMsgOptions = [];
        chatList.last.cbMsgOptions!.add(temp);
        break;
      }
    }
    print('aa ' + chatList.last.cbMsgOptions!.length.toString());
    print('aa ' + chatList.last.cbMsgOptions!.first.text!);

    var request = CBMsgOptionRequest()
      ..msgId = option.msgId
      ..optionId = option.optionId
      ..input = '';
    var res = await ApiManager.cbMsgOption(request);
    if (res.code == ResponseCode.Success) {
      if (option.nextMsgId != null) {
        cbContinueChat(option.nextMsgId!);
      }
    } else {
      print('cbMsgOption failed');
    }
    reloadSubject.add(true);
  }

  cbChatHistory(int pid, int psize) async {
    var res = await ApiManager.cbChatHistory(pid, psize);
    if (res.code == ResponseCode.Success) {
    } else {}
  }

  getChatLogic(ChatScreenNewType type) async {
    if (type == ChatScreenNewType.onboard) {
    } else {}

    reloadSubject.add(true);
  }
}
