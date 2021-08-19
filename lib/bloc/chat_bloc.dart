import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/models/chat_response2.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_router.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInit());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is GetFirstChatEvent) {
      yield* _mapGetFirstChatEventToState(event);
    } else if (event is GetNextChatEvent) {
      yield* _mapGetNextChatEventToState(event);
    } else if (event is SaveOptionEvent) {
      yield* _mapSaveOptionEventToState(event);
    }
  }

  Stream<ChatState> _mapGetFirstChatEventToState(GetFirstChatEvent event) async* {
    try {
      yield ChatLoading();

      // Get chat bot ID
      int? chatBotId;
      switch (event.chatType) {
        case ChatType.onBoarding:
          chatBotId = globals.param?.onBoardingCbId;
          break;

        case ChatType.mainBoarding: // todo test
          // chatBotId = globals.param?.onBoardingCbId; // todo test
          break;
      }

      // Validation
      if (chatBotId == null) {
        yield ChatFailed(LocaleKeys.noData);
        return;
      }

      // Get chat
      var request = ChatRequest()..cbId = globals.param!.onBoardingCbId!;
      var res = await ApiRouter.firstChat(request);
      if (res.code == ResponseCode.Success) {
        yield ChatSuccess(res, null);
      } else {
        yield ChatFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield ChatFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ChatState> _mapGetNextChatEventToState(GetNextChatEvent event) async* {
    try {
      yield ChatLoading();

      var res = await ApiRouter.continueChat(event.continueMsgId);
      if (res.code == ResponseCode.Success) {
        yield ChatSuccess(res, event.chatIndex);
      } else {
        yield ChatFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield ChatFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ChatState> _mapSaveOptionEventToState(SaveOptionEvent event) async* {
    try {
      yield ChatLoading();

      var res = await ApiRouter.msgOption(event.msgId, event.optionId);
      if (res.code == ResponseCode.Success) {
        yield SaveOptionSuccess();
      } else {
        yield SaveOptionFailed(res.message ?? LocaleKeys.failed);
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

class GetFirstChatEvent extends ChatEvent {
  final String chatType;

  const GetFirstChatEvent(this.chatType);

  @override
  List<Object> get props => [chatType];

  @override
  String toString() => 'GetFirstChatEvent { chatType: $chatType }';
}

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

  const SaveOptionEvent(this.msgId, this.optionId);

  @override
  List<Object> get props => [msgId, optionId];

  @override
  String toString() => 'SaveMsgOptionEvent { msgId: $msgId, optionId: $optionId }';
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

class ChatSuccess extends ChatState {
  final ChatResponse response;
  final int? chatIndex;

  const ChatSuccess(this.response, this.chatIndex);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'ChatSuccess { response: $response, chatIndex: $chatIndex }';
}

class ChatFailed extends ChatState {
  final String message;

  const ChatFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChatFailed { message: $message }';
}

class SaveOptionSuccess extends ChatState {}

class SaveOptionFailed extends ChatState {
  final String message;

  const SaveOptionFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SaveOptionFailed { message: $message }';
}
