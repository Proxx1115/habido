import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/first_chat_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_router.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInit());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is GetFirstChatEvent) {
      yield* _mapGetFirstChatEventToState();
    }
  }

  Stream<ChatState> _mapGetFirstChatEventToState() async* {
    try {
      yield ChatLoading();

      var res = await ApiRouter.firstChat(0);
      if (res.code == ResponseCode.Success) {
        yield FirstChatSuccess(res);
      } else {
        yield FirstChatFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield FirstChatFailed(LocaleKeys.errorOccurred);
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

class GetFirstChatEvent extends ChatEvent {}

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

class FirstChatSuccess extends ChatState {
  final FirstChatResponse response;

  const FirstChatSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'FirstChatSuccess { response: $response }';
}

class FirstChatFailed extends ChatState {
  final String message;

  const FirstChatFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'FirstChatFailed { message: $message }';
}
