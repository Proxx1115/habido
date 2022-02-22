import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chat_response.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_chatbots_model.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option_request.dart';
import 'package:habido_app/ui/chat/chat_screen_new.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:rxdart/subjects.dart';

class ChatScreenNewBloc {
  final reloadSubject = BehaviorSubject<bool>();
  final loadingSubject = BehaviorSubject<bool>();
  final bottomSubject = BehaviorSubject<bool>();
  final chatBotsSubject = BehaviorSubject<List<CBChatBotsModel>>();
  final isShowSubject = BehaviorSubject<bool>();

  List<CBChatResponse> chatList = [];
  ChatScreenNewType type = ChatScreenNewType.onboard;
  int pid = 1;
  int psize = 10;

  int chatbotId = 0;

  dismiss() {
    reloadSubject.close();
    loadingSubject.close();
    bottomSubject.close();
    chatBotsSubject.close();
    isShowSubject.close();
  }

  cbChatbots() async {
    var res = await ApiManager.cbChatbots();
    if (res.code == ResponseCode.Success) {
      if (type == ChatScreenNewType.main && res.chatbots!.length == 1) {
        chatbotId = res.chatbots!.first.cbId!;
        cbFirstChat();
      } else {
        chatBotsSubject.add(res.chatbots!);
      }
    } else {
      print('cbChatbots failed');
    }
  }

  cbFirstChat() async {
    var request = ChatRequest()..cbId = chatbotId;
    var res = await ApiManager.cbFirstChat(request);
    if (res.code == ResponseCode.Success) {
      chatList.add(res);
      if (res.isEnd == false && res.continueMsgId != null && res.hasOption == false) {
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
      if (res.isEnd == false && res.continueMsgId != null && res.hasOption == false) {
        cbContinueChat(res.continueMsgId!);
      } else {
        reloadSubject.add(true);
      }
    } else {
      print('cbContinueChat failed');
    }
  }

  cbMsgOption(CBMsgOption option, {String input = ''}) async {
    for (int i = 0; i < chatList.last.cbMsgOptions!.length; i++) {
      if (chatList.last.cbMsgOptions![i].optionId == option.optionId) {
        CBMsgOption temp = chatList.last.cbMsgOptions![i];
        temp.isSelected = true;
        chatList.last.cbMsgOptions = [];
        chatList.last.optionSelectedTime = DateTime.now().toString();
        chatList.last.cbMsgOptions!.add(temp);
        break;
      }
    }
    var request = CBMsgOptionRequest()
      ..msgId = option.msgId
      ..optionId = option.optionId
      ..input = input;
    var res = await ApiManager.cbMsgOption(request);
    if (res.code == ResponseCode.Success) {
      if (chatList.last.isEnd == true) {
        cbChatbots();
        pickChatBot();
      }

      if (option.nextMsgId != null && option.nextMsgId != 0) {
        cbContinueChat(option.nextMsgId!);
      }
    } else {
      print('cbMsgOption failed');
    }
    reloadSubject.add(true);
  }

  pickChatBot() {
    if (chatBotsSubject.hasValue && chatBotsSubject.value.length > 1) {
      CBChatResponse pickCb = new CBChatResponse(isEnd: true, msg: 'sda');
      chatList.add(pickCb);
    }
  }

  cbChatHistory() async {
    if (chatList.isNotEmpty && chatList.first.isFirst == true) return;

    var res = await ApiManager.cbChatHistory(pid, psize);
    if (res.code == ResponseCode.Success) {
      if (res.chatList!.isEmpty) {
        cbChatbots();
      } else {
        // res.chatList!.sort((a, b) => a.msgId! - b.msgId!);
        chatList.insertAll(0, res.chatList!);
        if (chatList.last.isEnd == true && chatList.last.cbMsgOptions == null) {
          cbChatbots();
          pickChatBot();
        }
        if (pid == 1) bottomSubject.add(true);
        pid++;
        reloadSubject.add(true);
      }
    } else {
      print('cbChatHistory failed');
    }
  }
}
