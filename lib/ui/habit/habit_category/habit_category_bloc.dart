import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitCategoryBloc extends Bloc<HabitCategoryEvent, HabitCategoryState> {
  HabitCategoryBloc() : super(HabitCategoryInit());

  @override
  Stream<HabitCategoryState> mapEventToState(HabitCategoryEvent event) async* {
    if (event is GetHabitCategoriesEvent) {
      yield* _mapGetHabitCategoriesEventToState();
    }
  }

  Stream<HabitCategoryState> _mapGetHabitCategoriesEventToState() async* {
    try {
      yield HabitCategoriesLoading();

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

abstract class HabitCategoryEvent extends Equatable {
  const HabitCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetHabitCategoriesEvent extends HabitCategoryEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitCategoryState extends Equatable {
  const HabitCategoryState();

  @override
  List<Object> get props => [];
}

class HabitCategoryInit extends HabitCategoryState {}

class HabitCategoriesLoading extends HabitCategoryState {}

class ContentEmpty extends HabitCategoryState {}

class ContentListSuccess extends HabitCategoryState {
  final List<Content> contentList;

  const ContentListSuccess(this.contentList);

  @override
  List<Object> get props => [contentList];

  @override
  String toString() => 'ContentListSuccess { contentList: $contentList }';
}

class ContentListFailed extends HabitCategoryState {
  final String message;

  const ContentListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
