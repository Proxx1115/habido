import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/http_utils.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInit());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is NavigateToPageEvent) {
      yield* _mapNavigateToPageToState(event.index);
    }
  }

  Stream<HomeState> _mapNavigateToPageToState(int index) async* {
    yield NavigateToPageState(index);
    yield HomeVoidState();
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
