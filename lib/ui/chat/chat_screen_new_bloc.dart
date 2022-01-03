import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:rxdart/subjects.dart';

class ChatScreenNewBloc {
  final reloadSubject = BehaviorSubject<bool>();
  final loadingSubject = BehaviorSubject<bool>();
  final bottomSubject = BehaviorSubject<bool>();

  List<CBChatResponse> chatList = [];

  int pid = 1;
  int psize = 5;

  int chatbotId = 15;

  dismiss() {
    reloadSubject.close();
    loadingSubject.close();
    bottomSubject.close();
  }

  cbChatbots() async {
    var res = await ApiManager.cbChatbots();
    if (res.code == ResponseCode.Success) {
      print('success');
    } else {
      print('cbChatbots failed');
    }
  }

  cbFirstChat() async {
    var request = ChatRequest()..cbId = chatbotId;
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

    var request = CBMsgOptionRequest()
      ..msgId = option.msgId
      ..optionId = option.optionId
      ..input = '';
    var res = await ApiManager.cbMsgOption(request);
    if (res.code == ResponseCode.Success) {
      if (option.nextMsgId != null && option.nextMsgId != 0) {
        cbContinueChat(option.nextMsgId!);
      }
    } else {
      print('cbMsgOption failed');
    }
    reloadSubject.add(true);
  }

  cbChatHistory() async {
    if (chatList.isNotEmpty && chatList.first.isFirst == true) return;
    // if (chatList.isNotEmpty && chatList.last.isEnd == true) return;

    var res = await ApiManager.cbChatHistory(pid, psize);
    if (res.code == ResponseCode.Success) {
      if (res.chatList!.isEmpty) {
        cbFirstChat();
      } else {
        res.chatList!.sort((a, b) => a.msgId! - b.msgId!);
        chatList.insertAll(0, res.chatList!);

        if (pid == 1) bottomSubject.add(true);
        pid++;
        reloadSubject.add(true);
      }
    } else {
      print('cbChatHistory failed');
    }
  }
}
