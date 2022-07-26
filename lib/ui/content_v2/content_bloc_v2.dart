import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content_tag_v2.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/models/psy_test_response_v2.dart';
import 'package:habido_app/models/test.dart';
import 'package:habido_app/models/test_name_with_tests.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class ContentBlocV2 extends Bloc<ContentEventV2, ContentStateV2> {
  ContentBlocV2() : super(ContentInitV2());

  @override
  Stream<ContentStateV2> mapEventToState(ContentEventV2 event) async* {
    if (event is GetHighlightedListEvent) {
      yield* _mapGetContentHighlightedListEventToState();
    } else if (event is GetContentEventV2) {
      yield* _mapGetContentHighlightedEventToState(event);
    } else if (event is GetContentTags) {
      yield* _mapGetContentTagsEventToState();
    } else if (event is GetContentFirst) {
      yield* _mapGetContentFirstEventToState(event);
    } else if (event is GetContentThenEvent) {
      yield* _mapGetContentThenEventToState(event);
    } else if (event is LikeContentEvent) {
      yield* _mapLikeContentEventToState(event);
    }
  }

  Stream<ContentStateV2> _mapGetContentHighlightedListEventToState() async* {
    try {
      yield ContentHighlightedListLoading();

      var res = await ApiManager.highLightedContentList();
      if (res.code == ResponseCode.Success && res.contentList != null && res.contentList!.length > 0) {
        yield ContentHighlightedListSuccess(res.contentList!);
      } else {
        yield ContentHighlightedListEmpty();
      }
    } catch (e) {
      yield ContentHighlightedListFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentStateV2> _mapGetContentHighlightedEventToState(GetContentEventV2 event) async* {
    try {
      yield ContentLoadingV2();

      ContentV2 res = await ApiManager.contentV2(event.contentId);
      if (res.code == ResponseCode.Success) {
        yield ContentSuccessV2(res);
      } else {
        yield ContentFailedV2(LocaleKeys.noData);
      }
    } catch (e) {
      yield ContentFailedV2(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentStateV2> _mapGetContentTagsEventToState() async* {
    try {
      yield ContentTagsLoading();

      var res = await ApiManager.contentTags();
      if (res.code == ResponseCode.Success && res.contentTags != null && res.contentTags!.length > 0) {
        // Tag list
        List<ContentTagV2> tagList = [];
        tagList = res.contentTags!;

        yield ContentTagsSuccess(tagList);
      } else {
        yield ContentTagsEmpty();
      }
    } catch (e) {
      yield ContentTagsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentStateV2> _mapGetContentFirstEventToState(GetContentFirst event) async* {
    try {
      yield ContentFirstLoading();

      var res = await ApiManager.contentFirst(event.name, event.searchText);
      print("Search Text: ${res.contentList}");
      if (res.code == ResponseCode.Success) {
        yield ContentFirstSuccess(res.contentList!);
      } else {
        yield ContentFirstFailed(LocaleKeys.noData);
      }
    } catch (e) {
      yield ContentFirstFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentStateV2> _mapGetContentThenEventToState(GetContentThenEvent event) async* {
    try {
      yield ContentThenLoading();

      var res = await ApiManager.contentThen(event.name, event.searchText, event.contentId);
      print("Then content: ${res.contentList}");
      if (res.code == ResponseCode.Success) {
        yield ContentThenSuccess(res.contentList!);
      } else {
        yield ContentThenFailed(LocaleKeys.noData);
      }
    } catch (e) {
      yield ContentThenFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentStateV2> _mapLikeContentEventToState(LikeContentEvent event) async* {
    try {
      yield ContentLikeLoading();

      var res = await ApiManager.contentLike(event.contentId);
      if (res.code == ResponseCode.Success) {
        yield ContentLikeSuccess();
      } else {
        yield ContentLikeFailed(LocaleKeys.noData);
      }
    } catch (e) {
      yield ContentLikeFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class ContentEventV2 extends Equatable {
  const ContentEventV2();

  @override
  List<Object> get props => [];
}

class GetHighlightedListEvent extends ContentEventV2 {}

class GetContentEventV2 extends ContentEventV2 {
  final int contentId;

  const GetContentEventV2(this.contentId);

  @override
  List<Object> get props => [contentId];

  @override
  String toString() => 'GetContentEvent { contentId: $contentId }';
}

class GetContentTags extends ContentEventV2 {}

class GetContentFirst extends ContentEventV2 {
  final String name;
  final String searchText;
  const GetContentFirst(this.name, this.searchText);

  @override
  List<Object> get props => [name, searchText];

  @override
  String toString() => 'GetContentFirst { GetContentFirst: $name $searchText }';
}

class GetContentThenEvent extends ContentEventV2 {
  final String name;
  final String searchText;
  final int contentId;
  const GetContentThenEvent(this.name, this.searchText, this.contentId);

  @override
  List<Object> get props => [name, searchText, contentId];

  @override
  String toString() => 'GetContentThen { GetContentThen: $name $searchText $contentId }';
}

class LikeContentEvent extends ContentEventV2 {
  final int contentId;
  const LikeContentEvent(this.contentId);

  @override
  List<Object> get props => [contentId];

  @override
  String toString() => 'GetContentThen { GetContentThen: $contentId }';
}

/// BLOC STATES
abstract class ContentStateV2 extends Equatable {
  const ContentStateV2();

  @override
  List<Object> get props => [];
}

class ContentInitV2 extends ContentStateV2 {}

/// CONTENT LIST STATES

class ContentHighlightedListLoading extends ContentStateV2 {}

class ContentHighlightedListEmpty extends ContentStateV2 {}

class ContentHighlightedListSuccess extends ContentStateV2 {
  final List<ContentV2> contentList;

  const ContentHighlightedListSuccess(
    this.contentList,
  );

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentListSuccess { contentList: $contentList}';
}

class ContentHighlightedListFailed extends ContentStateV2 {
  final String message;

  const ContentHighlightedListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// CONTENT STATES
class ContentLoadingV2 extends ContentStateV2 {}

class ContentSuccessV2 extends ContentStateV2 {
  final ContentV2 content;

  const ContentSuccessV2(this.content);

  @override
  List<Object> get props => [content];

  @override
  String toString() => 'ContentSuccess { content: $content }';
}

class ContentFailedV2 extends ContentStateV2 {
  final String message;

  const ContentFailedV2(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}

/// TAGS STATES
class ContentTagsLoading extends ContentStateV2 {}

class ContentTagsSuccess extends ContentStateV2 {
  final List<ContentTagV2> tagList;

  const ContentTagsSuccess(this.tagList);

  @override
  List<Object> get props => [tagList];

  @override
  String toString() => 'ContentTagsSuccess {tagList: $tagList }';
}

class ContentTagsEmpty extends ContentStateV2 {}

class ContentTagsFailed extends ContentStateV2 {
  final String message;

  const ContentTagsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentTagsFailed { message: $message }';
}

/// CONTENT FIRST STATES
class ContentFirstLoading extends ContentStateV2 {}

class ContentFirstSuccess extends ContentStateV2 {
  final List<ContentV2> contentList;

  const ContentFirstSuccess(this.contentList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentSuccess { content: $contentList }';
}

class ContentFirstFailed extends ContentStateV2 {
  final String message;

  const ContentFirstFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}

/// CONTENT THEN STATES
class ContentThenLoading extends ContentStateV2 {}

class ContentThenSuccess extends ContentStateV2 {
  final List<ContentV2> contentList;

  const ContentThenSuccess(this.contentList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentSuccess { content: $contentList }';
}

class ContentThenFailed extends ContentStateV2 {
  final String message;

  const ContentThenFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}

/// CONTENT LIKE STATES
class ContentLikeLoading extends ContentStateV2 {}

class ContentLikeSuccess extends ContentStateV2 {}

class ContentLikeFailed extends ContentStateV2 {
  final String message;

  const ContentLikeFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}
