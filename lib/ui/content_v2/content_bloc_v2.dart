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

class ContentBlocV2 extends Bloc<ContentHighlightedEvent, ContentHighlightedState> {
  ContentBlocV2() : super(ContentInitV2());

  @override
  Stream<ContentHighlightedState> mapEventToState(ContentHighlightedEvent event) async* {
    if (event is GetHighlightedListEvent) {
      yield* _mapGetContentHighlightedListEventToState();
    } else if (event is GetContentEventV2) {
      yield* _mapGetContentHighlightedEventToState(event);
    } else if (event is GetContentTags) {
      yield* _mapGetContentTagsEventToState();
    } else if (event is GetContentFilter) {
      yield* _mapGetContentFilterEventToState(event);
    } else if (event is GetTestListEvent) {
      yield* _mapGetTestEventToState();
    }
  }

  Stream<ContentHighlightedState> _mapGetContentHighlightedListEventToState() async* {
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

  Stream<ContentHighlightedState> _mapGetContentHighlightedEventToState(GetContentEventV2 event) async* {
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

  Stream<ContentHighlightedState> _mapGetContentTagsEventToState() async* {
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

  Stream<ContentHighlightedState> _mapGetContentFilterEventToState(GetContentFilter event) async* {
    try {
      yield ContentFilterLoading();

      var res = await ApiManager.contentFilter(event.name, event.pid, event.pSize);
      if (res.code == ResponseCode.Success) {
        yield ContentFilterSuccess(res.contentList!);
      } else {
        yield ContentFilterFailed(LocaleKeys.noData);
      }
    } catch (e) {
      yield ContentFilterFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentHighlightedState> _mapGetTestEventToState() async* {
    try {
      yield TestListLoading();

      var res = await ApiManager.psyTestList();
      print("yelaData:${res.testNameWithTests}");
      if (res.code == ResponseCode.Success && res.testNameWithTests != null && res.testNameWithTests!.length > 0) {
        yield TestListSuccess(res.testNameWithTests!);
      } else {
        yield TestListEmpty();
      }
    } catch (e) {
      yield TestListFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class ContentHighlightedEvent extends Equatable {
  const ContentHighlightedEvent();

  @override
  List<Object> get props => [];
}

class GetHighlightedListEvent extends ContentHighlightedEvent {}

class GetContentEventV2 extends ContentHighlightedEvent {
  final int contentId;

  const GetContentEventV2(this.contentId);

  @override
  List<Object> get props => [contentId];

  @override
  String toString() => 'GetContentEvent { contentId: $contentId }';
}

class GetContentTags extends ContentHighlightedEvent {}

class GetContentFilter extends ContentHighlightedEvent {
  final String name;
  final int pid;
  final int pSize;

  const GetContentFilter(this.name, this.pid, this.pSize);

  @override
  List<Object> get props => [name, pid, pSize];

  @override
  String toString() => 'GetContentEvent { contentId: $name $pid $pSize }';
}

class GetTestListEvent extends ContentHighlightedEvent {}

/// BLOC STATES
abstract class ContentHighlightedState extends Equatable {
  const ContentHighlightedState();

  @override
  List<Object> get props => [];
}

class ContentInitV2 extends ContentHighlightedState {}

/// CONTENT LIST STATES

class ContentHighlightedListLoading extends ContentHighlightedState {}

class ContentHighlightedListEmpty extends ContentHighlightedState {}

class ContentHighlightedListSuccess extends ContentHighlightedState {
  final List<ContentV2> contentList;

  const ContentHighlightedListSuccess(
    this.contentList,
  );

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentListSuccess { contentList: $contentList}';
}

class ContentHighlightedListFailed extends ContentHighlightedState {
  final String message;

  const ContentHighlightedListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// CONTENT STATES
class ContentLoadingV2 extends ContentHighlightedState {}

class ContentSuccessV2 extends ContentHighlightedState {
  final ContentV2 content;

  const ContentSuccessV2(this.content);

  @override
  List<Object> get props => [content];

  @override
  String toString() => 'ContentSuccess { content: $content }';
}

class ContentFailedV2 extends ContentHighlightedState {
  final String message;

  const ContentFailedV2(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}

/// TAGS STATES
class ContentTagsLoading extends ContentHighlightedState {}

class ContentTagsSuccess extends ContentHighlightedState {
  final List<ContentTagV2> tagList;

  const ContentTagsSuccess(this.tagList);

  @override
  List<Object> get props => [tagList];

  @override
  String toString() => 'ContentTagsSuccess {tagList: $tagList }';
}

class ContentTagsEmpty extends ContentHighlightedState {}

class ContentTagsFailed extends ContentHighlightedState {
  final String message;

  const ContentTagsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentTagsFailed { message: $message }';
}

/// CONTENT STATES
class ContentFilterLoading extends ContentHighlightedState {}

class ContentFilterSuccess extends ContentHighlightedState {
  final List<ContentV2> contentList;

  const ContentFilterSuccess(this.contentList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentSuccess { content: $contentList }';
}

class ContentFilterFailed extends ContentHighlightedState {
  final String message;

  const ContentFilterFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}

/// TEST LIST STATES

class TestListLoading extends ContentHighlightedState {}

class TestListEmpty extends ContentHighlightedState {}

class TestListSuccess extends ContentHighlightedState {
  final List<TestNameWithTests> testNameWithTests;

  const TestListSuccess(
    this.testNameWithTests,
  );

  @override
  List<Object> get props => [testNameWithTests];

  @override
  String toString() => 'ContentListSuccess { contentList: $testNameWithTests}';
}

class TestListFailed extends ContentHighlightedState {
  final String message;

  const TestListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
