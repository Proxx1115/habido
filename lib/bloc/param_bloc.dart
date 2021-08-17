import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_router.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/models/param_response.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ParamBloc extends Bloc<ParamEvent, ParamState> {
  ParamBloc() : super(ParamInit());

  @override
  Stream<ParamState> mapEventToState(ParamEvent event) async* {
    if (event is GetParamEvent) {
      yield* _mapInitEventToState();
    }
  }

  Stream<ParamState> _mapInitEventToState() async* {
    try {
      yield ParamLoading();

      var res = await ApiRouter.param();
      if (res.code == ResponseCode.Success) {
        yield ParamSuccess(res);
      } else {
        yield ParamFailed(res.message ?? LocaleKeys.noData);
      }
    } catch (e) {
      yield ParamFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ParamEvent extends Equatable {
  const ParamEvent();

  @override
  List<Object> get props => [];
}

class GetParamEvent extends ParamEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ParamState extends Equatable {
  const ParamState();

  @override
  List<Object> get props => [];
}

class ParamInit extends ParamState {}

class ParamLoading extends ParamState {}

class ParamSuccess extends ParamState {
  final ParamResponse response;

  const ParamSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'ParamSuccess { response: $response }';
}

class ParamFailed extends ParamState {
  final String message;

  const ParamFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ParamFailed { message: $message }';
}
