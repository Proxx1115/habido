import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/custom_banner.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  SliderBloc() : super(SliderInit());

  @override
  Stream<SliderState> mapEventToState(SliderEvent event) async* {
    if (event is GetBannersEvent) {
      yield* _mapGetBannersEventToState();
    }
  }

  Stream<SliderState> _mapGetBannersEventToState() async* {
    try {
      yield SliderLoading();
      var res = await ApiManager.banners();
      if (res.code == ResponseCode.Success && res.bannerList != null && res.bannerList!.length > 0) {
        yield BannersSuccess(res.bannerList!);
      } else {
        yield BannersFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield BannersFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class SliderEvent extends Equatable {
  const SliderEvent();

  @override
  List<Object> get props => [];
}

class GetBannersEvent extends SliderEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class SliderState extends Equatable {
  const SliderState();

  @override
  List<Object> get props => [];
}

class SliderInit extends SliderState {}

class SliderLoading extends SliderState {}

class SliderVoid extends SliderState {}

class BannersSuccess extends SliderState {
  final List<CustomBanner> bannerList;

  const BannersSuccess(this.bannerList);

  @override
  List<Object> get props => [bannerList];

  @override
  String toString() => 'BannersSuccess { bannerList: $bannerList }';
}

class BannersFailed extends SliderState {
  final String message;

  const BannersFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'BannersFailed { message: $message }';
}
