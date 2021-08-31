import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/custom_banner.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class CarSliderBloc extends Bloc<CarSliderEvent, CarSliderState> {
  CarSliderBloc() : super(CarSliderInit());

  @override
  Stream<CarSliderState> mapEventToState(CarSliderEvent event) async* {
    if (event is GetBannersEvent) {
      yield* _mapGetBannersEventToState();
    }
  }

  Stream<CarSliderState> _mapGetBannersEventToState() async* {
    try {
      yield CarSliderLoading();
      var res = await ApiManager.banners();
      if (res.code == ResponseCode.Success && res.bannerList != null && res.bannerList!.length > 0) {
        yield BannersSuccess(res.bannerList!);
      } else {
        yield BannersFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.failed);
      }
    } catch (e) {
      yield BannersFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CarSliderEvent extends Equatable {
  const CarSliderEvent();

  @override
  List<Object> get props => [];
}

class GetBannersEvent extends CarSliderEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CarSliderState extends Equatable {
  const CarSliderState();

  @override
  List<Object> get props => [];
}

class CarSliderInit extends CarSliderState {}

class CarSliderLoading extends CarSliderState {}

class CarSliderVoid extends CarSliderState {}

class BannersSuccess extends CarSliderState {
  final List<CustomBanner> bannerList;

  const BannersSuccess(this.bannerList);

  @override
  List<Object> get props => [bannerList];

  @override
  String toString() => 'BannersSuccess { bannerList: $bannerList }';
}

class BannersFailed extends CarSliderState {
  final String message;

  const BannersFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'BannersFailed { message: $message }';
}
