import 'package:flutter/material.dart';
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
  bool isVisibleOptions = true;

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
      res.cbMsgOptions!.length > 0 ? isVisibleOptions = true : isVisibleOptions = false;
      reloadSubject.add(true);
      if (res.isEnd == false && res.continueMsgId != null && res.hasOption == false) {
        Future.delayed(const Duration(milliseconds: 2700), () {
          cbContinueChat(res.continueMsgId!);
          isVisibleOptions = true;
        });
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
      reloadSubject.add(true);
      if (res.isEnd == false && res.continueMsgId != null && res.hasOption == false) {
        isVisibleOptions = false;
        Future.delayed(const Duration(milliseconds: 2300), () {
          cbContinueChat(res.continueMsgId!);
          isVisibleOptions = true;
        });
      } else if (chatList.last.isEnd == true && chatList.last.cbMsgOptions!.isEmpty) {
        // Future.delayed(const Duration(milliseconds: 1300), () {
        //   _wannaTalkMore();
        // });
        _wannaTalkMore();
        reloadSubject.add(true);
      }
    } else {
      print('cbContinueChat failed');
    }
  }

  cbMsgOption(CBMsgOption option, {String input = ''}) async {
    option.isSelected = true;
    chatList.last.cbMsgOptions = [];
    isVisibleOptions = false;
    chatList.last.optionSelectedTime = DateTime.now().toString();
    chatList.last.cbMsgOptions!.add(option);

    // for (int i = 0; i < chatList.last.cbMsgOptions!.length; i++) {
    //   if (chatList.last.cbMsgOptions![i].optionId == option.optionId) {
    //     CBMsgOption temp = chatList.last.cbMsgOptions![i];
    //     temp.isSelected = true;
    //     chatList.last.cbMsgOptions = [];
    //     chatList.last.optionSelectedTime = DateTime.now().toString();
    //     chatList.last.cbMsgOptions!.add(temp);
    //     isVisibleOptions = false;
    //     break;
    //   }
    // }
    if (option.isAbstract == false) {
      var request = CBMsgOptionRequest()
        ..msgId = option.msgId
        ..optionId = option.optionId
        ..input = input;
      var res = await ApiManager.cbMsgOption(request);
      if (res.code == ResponseCode.Success) {
        if (chatList.last.isEnd == true) {
          _wannaTalkMore();
          if (chatList.last.cbMsgOptions!.first.meaning == 'Positive' && chatList.last.cbMsgOptions!.first.isSelected == true) cbChatbots();
          pickChatBot();
        }

        if (option.nextMsgId != null && option.nextMsgId != 0) {
          Future.delayed(const Duration(milliseconds: 1100), () {
            cbContinueChat(option.nextMsgId!);
            isVisibleOptions = true;
          });
        }
      } else {
        print('cbMsgOption failed');
      }
    } else if (option.isAbstract == true && option.meaning!.toLowerCase() == 'positive') {
      reloadSubject.add(true);
      cbChatbots();
      pickChatBot();
    } else if (option.isAbstract == true && option.meaning!.toLowerCase() == 'negative') {
      isVisibleOptions = false;
      Future.delayed(const Duration(milliseconds: 800), () {
        _byeChatBot();
        reloadSubject.add(true);
      });
    }
    reloadSubject.add(true);
  }

  _byeChatBot() {
    CBChatResponse bye = CBChatResponse(
        ownerType: 'Text',
        msg: 'Баяртай',
        continueMsgId: 0,
        isEnd: false,
        hasOption: true,
        isFirst: false,
        cbId: 0,
        msgId: 0,
        msgSentTime: DateTime.now().toString(),
        optionSelectedTime: DateTime.now().toString());
    chatList.add(bye);
  }

  _wannaTalkMore() {
    CBChatResponse uWannaTalkMore = CBChatResponse(
        ownerType: 'Text',
        msg: 'Үргэлжлүүлээд ярилцмаар байна уу?',
        continueMsgId: 0,
        isEnd: false,
        hasOption: true,
        isFirst: false,
        cbId: 0,
        msgId: 0,
        msgSentTime: DateTime.now().toString(),
        optionSelectedTime: DateTime.now().toString());
    List<CBMsgOption> options = [];
    CBMsgOption firstOption = CBMsgOption(
      text: 'Тэгье',
      meaning: 'Positive',
      optionType: 'Text',
      isSelected: false,
      isAbstract: true,
    );
    CBMsgOption secondOption = CBMsgOption(
      text: 'Дараа ярилцацгаая',
      meaning: 'Negative',
      optionType: 'Text',
      isSelected: false,
      isAbstract: true,
    );
    options.add(firstOption);
    options.add(secondOption);
    uWannaTalkMore.cbMsgOptions = options;
    isVisibleOptions = true;
    chatList.add(uWannaTalkMore);
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
        if ((chatList.last.isEnd == true && chatList.last.cbMsgOptions!.length == 0) ||
            (chatList.last.isEnd == true && chatList.last.cbMsgOptions!.where((element) => element.isSelected == true).length == 1)) {
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
