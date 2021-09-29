import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/content_tag.dart';
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
    } else if (event is GetContentEvent) {
      yield* _mapGetContentEventToState(event);
    }
  }

  Stream<ContentState> _mapGetContentListEventToState() async* {
    try {
      yield ContentListLoading();

      var res = await ApiManager.contentList();
      if (res.code == ResponseCode.Success && res.contentList != null && res.contentList!.length > 0) {
        // Tag list
        List<ContentTag> tagList = [];
        if (res.contentList != null && res.contentList!.isNotEmpty) {
          for (var content in res.contentList!) {
            if (content.tags != null && content.tags!.isNotEmpty) {
              for (var tag in content.tags!) {
                bool isUnique = false;
                for (var el in tagList) {
                  if (el.name == tag.name) isUnique = true;
                }

                if (!isUnique) tagList.add(tag);
              }
            }
          }
        }

        yield ContentListSuccess(res.contentList!, tagList);
      } else {
        yield ContentListEmpty();
      }
    } catch (e) {
      yield ContentListFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentState> _mapGetContentEventToState(GetContentEvent event) async* {
    try {
      yield ContentLoading();

      var res = await ApiManager.content(event.contentId);
      if (res.code == ResponseCode.Success) {
        yield ContentSuccess(res);
      } else {
        yield ContentFailed(LocaleKeys.noData);
      }
    } catch (e) {
      yield ContentFailed(LocaleKeys.errorOccurred);
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

class GetContentEvent extends ContentEvent {
  final int contentId;

  const GetContentEvent(this.contentId);

  @override
  List<Object> get props => [contentId];

  @override
  String toString() => 'GetContentEvent { contentId: $contentId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInit extends ContentState {}

class ContentListLoading extends ContentState {}

class ContentLoading extends ContentState {}

class ContentListEmpty extends ContentState {}

class ContentListSuccess extends ContentState {
  final List<Content> contentList;
  final List<ContentTag> tagList;

  const ContentListSuccess(this.contentList, this.tagList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentListSuccess { contentList: $contentList, tagList: $tagList }';
}

class ContentListFailed extends ContentState {
  final String message;

  const ContentListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

class ContentSuccess extends ContentState {
  final Content content;

  const ContentSuccess(this.content);

  @override
  List<Object> get props => [content];

  @override
  String toString() => 'ContentSuccess { content: $content }';
}

class ContentFailed extends ContentState {
  final String message;

  const ContentFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}
