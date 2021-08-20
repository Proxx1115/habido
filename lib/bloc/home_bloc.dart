import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // else if (event is GetSliderImages) {
    //   yield* _mapGetSliderImagesToState();
    // } else if (event is SessionExpiredEvent) {
    //   yield* _mapSessionExpiredEventToState();
    // }
  }

  Stream<HomeState> _mapNavigateToPageToState(int index) async* {
    yield NavigateToPageState(index);
    yield EmptyState();
  }

// Stream<HomeState> _mapGetSliderImagesToState() async* {
//   try {
//     yield SliderLoading();
//     var res = await ApiManager.getSliderImages();
//     if (res.code == ResponseCode.Success) {
//       yield GetSliderImagesSuccess(res.bannerList);
//     } else {
//       yield GetSliderImagesFailed(res.message);
//     }
//   } catch (e) {
//     yield GetSliderImagesFailed(AppText.errorOccurred);
//   }
// }

// Stream<HomeState> _mapSessionExpiredEventToState() async* {
//   AuthHelper.logout();
//   yield SessionExpiredState();
// }
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

class GetSliderImages extends HomeEvent {}

class SessionExpiredEvent extends HomeEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInit extends HomeState {}

class SliderLoading extends HomeState {}

class EmptyState extends HomeState {}

class SessionExpiredState extends HomeState {}

class NavigateToPageState extends HomeState {
  final int index;

  const NavigateToPageState(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'NavigateToPageState { index: $index }';
}

// class GetSliderImagesSuccess extends HomeState {
//   final List<CustomBanner> bannerList;
//
//   const GetSliderImagesSuccess([this.bannerList]);
//
//   @override
//   List<Object> get props => [bannerList];
//
//   @override
//   String toString() => 'GetSliderImagesSuccess { imageList: $bannerList }';
// }

// class GetSliderImagesFailed extends HomeState {
//   final String msg;
//
//   const GetSliderImagesFailed([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'GetSliderImagesFailed { msg: $msg }';
// }
