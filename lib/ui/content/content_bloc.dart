import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ContentBloc() : super(ContentInit());

  @override
  Stream<ContentState> mapEventToState(ContentEvent event) async* {
    if (event is GetContentListEvent) {
      yield* _mapGetContentListEventToState();
    }
  }

  Stream<ContentState> _mapGetContentListEventToState() async* {
    try {
      yield ContentLoading();

      var res = await ApiManager.contentList();
      if (res.code == ResponseCode.Success && res.contentList != null && res.contentList!.length > 0) {
        yield ContentListSuccess(res.contentList!);
      } else {
        yield ContentEmpty();
      }
    } catch (e) {
      yield ContentListFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class GetContentListEvent extends ContentEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInit extends ContentState {}

class ContentLoading extends ContentState {}

class ContentEmpty extends ContentState {}

class ContentListSuccess extends ContentState {
  final List<Content> contentList;

  const ContentListSuccess(this.contentList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentListSuccess { contentList: $contentList }';
}

class ContentListFailed extends ContentState {
  final String message;

  const ContentListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
