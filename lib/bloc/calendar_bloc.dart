import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/models/param_response.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInit());

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if (event is GetCalendarEvent) {
      yield* _mapInitEventToState();
    }
  }

  Stream<CalendarState> _mapInitEventToState() async* {
    try {
      yield ParamLoading();

      var res = await ApiManager.param();
      if (res.code == ResponseCode.Success) {
        yield ParamSuccess(res);
      } else {
        yield ParamFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield ParamFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class GetCalendarEvent extends CalendarEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInit extends CalendarState {}

class ParamLoading extends CalendarState {}

class ParamSuccess extends CalendarState {
  final ParamResponse response;

  const ParamSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'ParamSuccess { response: $response }';
}

class ParamFailed extends CalendarState {
  final String message;

  const ParamFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ParamFailed { message: $message }';
}
