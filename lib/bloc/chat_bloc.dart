import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/chat_request.dart';
import 'package:habido_app/models/chat_response.dart';
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
        yield ChatSuccess(res);
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

      var res = await ApiRouter.continueChat(event.msgId);
      if (res.code == ResponseCode.Success) {
        yield ChatSuccess(res);
      } else {
        yield ChatFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield ChatFailed(LocaleKeys.errorOccurred);
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
  final int msgId;

  const GetNextChatEvent(this.msgId);

  @override
  List<Object> get props => [msgId];

  @override
  String toString() => 'GetNextChatEvent { msgId: $msgId }';
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

  const ChatSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'ChatSuccess { response: $response }';
}

class ChatFailed extends ChatState {
  final String message;

  const ChatFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChatFailed { message: $message }';
}
