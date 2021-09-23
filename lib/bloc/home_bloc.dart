import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInit());

  // Tab bar
  int currentTabIndex = 0;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is NavigateToPageEvent) {
      yield* _mapNavigateToPageToState(event.index);
    } else if (event is HomeShowcaseEvent) {
      yield* _mapHomeShowcaseEventState(event);
    }
  }

  Stream<HomeState> _mapNavigateToPageToState(int index) async* {
    currentTabIndex = index;
    yield NavigateToPageState(index);
    yield HomeVoidState();
  }

  Stream<HomeState> _mapHomeShowcaseEventState(HomeShowcaseEvent event) async* {
    if (!SharedPref.getShowcaseHasShown(event.showcaseKeyName)) {
      List<GlobalKey> keyList = ShowcaseKey.getKeysByName(event.showcaseKeyName);
      if (keyList.isNotEmpty) {
        yield HomeShowcaseState(keyList);
        SharedPref.setShowcaseHasShown(event.showcaseKeyName, true);
      }
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class NavigateToPageEvent extends HomeEvent {
  final int index;

  const NavigateToPageEvent(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'NavigateToPage { index: $index }';
}

class HomeShowcaseEvent extends HomeEvent {
  final String showcaseKeyName;

  const HomeShowcaseEvent(this.showcaseKeyName);

  @override
  List<Object> get props => [showcaseKeyName];

  @override
  String toString() => 'DashboardShowcaseEvent { showcaseKeyNameList: $showcaseKeyName }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInit extends HomeState {}

class HomeVoidState extends HomeState {}

class NavigateToPageState extends HomeState {
  final int index;

  const NavigateToPageState(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'NavigateToPageState { index: $index }';
}

class HomeShowcaseState extends HomeState {
  final List<GlobalKey> showcaseKeyList;

  const HomeShowcaseState(this.showcaseKeyList);

  @override
  List<Object> get props => [showcaseKeyList];

  @override
  String toString() => 'DashboardShowcaseState { showcaseKeyList: $showcaseKeyList }';
}
