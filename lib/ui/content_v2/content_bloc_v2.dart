import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content_tag_v2.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class ContentBlocV2 extends Bloc<ContentEventV2, ContentStateV2> {
  ContentBlocV2() : super(ContentInitV2());

  @override
  Stream<ContentStateV2> mapEventToState(ContentEventV2 event) async* {
    if (event is GetContentListEventV2) {
      yield* _mapGetContentListEventToStateV2();
    } else if (event is GetContentEventV2) {
      yield* _mapGetContentEventToStateV2(event);
    } else if (event is GetContentTags) {
      yield* _mapGetContentTagEventToState();
    }
  }

  Stream<ContentStateV2> _mapGetContentListEventToStateV2() async* {
    try {
      yield ContentListLoadingV2();

      var res = await ApiManager.highLightedContentList();
      if (res.code == ResponseCode.Success && res.contentList != null && res.contentList!.length > 0) {
        // Tag list
        List<ContentTagV2> tagList = [];
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

        yield ContentListSuccessV2(res.contentList!, tagList);
      } else {
        yield ContentListEmptyV2();
      }
    } catch (e) {
      yield ContentListFailedV2(LocaleKeys.errorOccurred);
    }
  }

  Stream<ContentStateV2> _mapGetContentEventToStateV2(GetContentEventV2 event) async* {
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

  Stream<ContentStateV2> _mapGetContentTagEventToState() async* {
    // try {
    //   yield ContentTagsLoading();
    //
    //   var res = await ApiManager.contentTags();
    //   if (res.code == ResponseCode.Success) {
    //     yield ContentTagsSuccess(res);
    //   } else {
    //     yield ContentFailedTagV2(LocaleKeys.noData);
    //   }
    // } catch (e) {
    //   yield ContentFailedTagV2(LocaleKeys.errorOccurred);
    // }
    var res = await ApiManager.contentTags();
    // print("TAGSS:$res");
    try {
      yield ContentTagsLoading();

      var res = await ApiManager.contentTags();
      // print("TAGSS:$res");
      // if (res.code == ResponseCode.Success && res.contentList != null && res.contentList!.length > 0) {
      if (res.code == ResponseCode.Success) {
        // Tag list
        List<ContentTagV2> tagList = [];
        if (res.data != null && res.data!.isNotEmpty) {
          for (var tag in res.data!) {
            // bool isUnique = false;
            // for (var el in tagList) {
            //   if (el.name == tag.name) isUnique = true;
            // }

            // if (!isUnique) tagList.add(tag);
            tagList.add(tag);
          }
        }

        yield ContentTagsSuccess(tagList);
      } else {
        yield ContentTagsEmpty();
      }
    } catch (e) {
      yield ContentTagsFailedV2(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class ContentEventV2 extends Equatable {
  const ContentEventV2();

  @override
  List<Object> get props => [];
}

class GetContentListEventV2 extends ContentEventV2 {}

class GetContentEventV2 extends ContentEventV2 {
  final int contentId;

  const GetContentEventV2(this.contentId);

  @override
  List<Object> get props => [contentId];

  @override
  String toString() => 'GetContentEvent { contentId: $contentId }';
}

class GetContentTags extends ContentEventV2 {}

/// BLOC STATES
abstract class ContentStateV2 extends Equatable {
  const ContentStateV2();

  @override
  List<Object> get props => [];
}

class ContentInitV2 extends ContentStateV2 {}

class ContentListLoadingV2 extends ContentStateV2 {}

class ContentTagsLoading extends ContentStateV2 {}

class ContentLoadingV2 extends ContentStateV2 {}

class ContentListEmptyV2 extends ContentStateV2 {}

class ContentTagsEmpty extends ContentStateV2 {}

class ContentListSuccessV2 extends ContentStateV2 {
  final List<ContentV2> contentList;
  final List<ContentTagV2> tagList;

  const ContentListSuccessV2(this.contentList, this.tagList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentListSuccess { contentList: $contentList, tagList: $tagList }';
}

class ContentTagsSuccess extends ContentStateV2 {
  final List<ContentTagV2> tagList;

  const ContentTagsSuccess(this.tagList);

  @override
  List<Object> get props => [tagList];

  @override
  String toString() => 'ContentListSuccess {tagList: $tagList }';
}

class ContentListFailedV2 extends ContentStateV2 {
  final String message;

  const ContentListFailedV2(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

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

class ContentFailedTagV2 extends ContentStateV2 {
  final String message;

  const ContentFailedTagV2(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentFailed { message: $message }';
}

class ContentTagsFailedV2 extends ContentStateV2 {
  final String message;

  const ContentTagsFailedV2(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentTagsFailed { message: $message }';
}
