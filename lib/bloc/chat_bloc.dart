import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/models/chat_response.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/models/chatbots_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInit());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is GetChatbotsEvent) {
      yield* _mapGetChatbotsEventToState(event);
    }
    // else if (event is GetFirstChatEvent) {
    //   yield* _mapGetFirstChatEventToState(event);
    // }
    else if (event is GetNextChatEvent) {
      yield* _mapGetNextChatEventToState(event);
    } else if (event is SaveOptionEvent) {
      yield* _mapSaveOptionEventToState(event);
    }
  }

  Stream<ChatState> _mapGetChatbotsEventToState(GetChatbotsEvent event) async* {
    try {
      yield ChatLoading();

      var chatbotsResponse = await ApiManager.chatbots();
      if (chatbotsResponse.code == ResponseCode.Success) {
        // Get chat bot ID

        switch (event.chatType) {
          case ChatType.onboarding:

            /// Get onboarding chat
            var request = ChatRequest()..cbId = chatbotsResponse.onBoardingCbId;
            var res = await ApiManager.firstChat(request);
            if (res.code == ResponseCode.Success) {
              yield GetChatSuccess(res, null);
            } else {
              yield GetChatFailed(ApiHelper.getFailedMessage(res.message));
            }
            break;

          case ChatType.assistant:
            if (chatbotsResponse.isAssistantChatDone ?? false) {
              /// Get chat history
              var res = await ApiManager.chatHistory(chatbotsResponse.assistantCbId ?? 0);
              if (res.code == ResponseCode.Success) {
                yield ChatHistorySuccess(res.chatList ?? []);
              } else {
                yield ChatHistoryFailed(ApiHelper.getFailedMessage(res.message));
              }
            } else {
              /// Get assistant chat
              var request = ChatRequest()..cbId = chatbotsResponse.assistantCbId;
              var res = await ApiManager.firstChat(request);
              if (res.code == ResponseCode.Success) {
                yield GetChatSuccess(res, null);
              } else {
                yield GetChatFailed(ApiHelper.getFailedMessage(res.message));
              }
            }
            break;
        }
      } else {
        yield GetChatbotsFailed(ApiHelper.getFailedMessage(chatbotsResponse.message));
      }
    } catch (e) {
      yield GetChatbotsFailed(LocaleKeys.errorOccurred);
    }
  }

  // Stream<ChatState> _mapGetFirstChatEventToState(GetFirstChatEvent event) async* {
  // try {
  //   yield ChatLoading();
  //
  //   // Validation
  //   if (globals.param == null || globals.param!.assistantCbId == null || globals.param!.onBoardingCbId == null) {
  //     var paramRes = await ApiManager.param();
  //   }
  //

  // } catch (e) {
  //   yield ChatFailed(LocaleKeys.errorOccurred);
  // }
  // }

  Stream<ChatState> _mapGetNextChatEventToState(GetNextChatEvent event) async* {
    try {
      yield ChatLoading();

      var res = await ApiManager.continueChat(event.continueMsgId);
      if (res.code == ResponseCode.Success) {
        yield GetChatSuccess(res, event.chatIndex);
      } else {
        yield GetChatFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield GetChatFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ChatState> _mapSaveOptionEventToState(SaveOptionEvent event) async* {
    try {
      yield ChatLoading();

      var res = await ApiManager.msgOption(event.msgId, event.optionId);
      if (res.code == ResponseCode.Success) {
        yield GetChatSuccess(res, event.chatIndex);
      } else {
        print('Option хадгалж чадсангүй');
        yield SaveOptionFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SaveOptionFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatbotsEvent extends ChatEvent {
  final String chatType;

  const GetChatbotsEvent(this.chatType);

  @override
  List<Object> get props => [chatType];

  @override
  String toString() => 'GetChatbotsEvent { chatType: $chatType }';
}

// class GetFirstChatEvent extends ChatEvent {
//   final String chatType;
//
//   const GetFirstChatEvent(this.chatType);
//
//   @override
//   List<Object> get props => [chatType];
//
//   @override
//   String toString() => 'GetFirstChatEvent { chatType: $chatType }';
// }

class GetNextChatEvent extends ChatEvent {
  final int continueMsgId;
  final int chatIndex;

  const GetNextChatEvent(this.continueMsgId, this.chatIndex);

  @override
  List<Object> get props => [continueMsgId, chatIndex];

  @override
  String toString() => 'GetNextChatEvent {  continueMsgId: $continueMsgId, chatIndex: $chatIndex }';
}

class SaveOptionEvent extends ChatEvent {
  final int msgId;
  final int optionId;
  final int chatIndex;

  const SaveOptionEvent(this.msgId, this.optionId, this.chatIndex);

  @override
  List<Object> get props => [msgId, optionId, chatIndex];

  @override
  String toString() => 'SaveMsgOptionEvent { msgId: $msgId, optionId: $optionId, chatIndex: $chatIndex }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInit extends ChatState {}

class ChatLoading extends ChatState {}

class GetChatbotsSuccess extends ChatState {
  final ChatbotsResponse response;

  const GetChatbotsSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'GetChatbotsSuccess { response: $response }';
}

class GetChatbotsFailed extends ChatState {
  final String message;

  const GetChatbotsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetChatbotsFailed { message: $message }';
}

class GetChatSuccess extends ChatState {
  final ChatResponse response;
  final int? chatIndex;

  const GetChatSuccess(this.response, this.chatIndex);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'ChatSuccess { response: $response, chatIndex: $chatIndex }';
}

class GetChatFailed extends ChatState {
  final String message;

  const GetChatFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChatFailed { message: $message }';
}

class ChatHistorySuccess extends ChatState {
  final List<ChatResponse>? chatList;

  const ChatHistorySuccess(this.chatList);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ChatHistorySuccess { chatList: $chatList }';
}

class ChatHistoryFailed extends ChatState {
  final String message;

  const ChatHistoryFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChatHistoryFailed { message: $message }';
}

class SaveOptionSuccess extends ChatState {
  final int nextMsgId;

  const SaveOptionSuccess(this.nextMsgId);

  @override
  List<Object> get props => [nextMsgId];

  @override
  String toString() => 'SaveOptionSuccess { nextMsgId: $nextMsgId }';
}

class SaveOptionFailed extends ChatState {
  final String message;

  const SaveOptionFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SaveOptionFailed { message: $message }';
}
