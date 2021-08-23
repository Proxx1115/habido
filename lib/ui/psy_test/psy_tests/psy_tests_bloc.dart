import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PsyTestBloc extends Bloc<PsyTestEvent, PsyTestState> {
  PsyTestBloc() : super(PsyTestsInit());

  @override
  Stream<PsyTestState> mapEventToState(PsyTestEvent event) async* {
    if (event is GetPsyTestsEvent) {
      yield* _mapGetPsyTestsEventToState(event);
    }
  }

  Stream<PsyTestState> _mapGetPsyTestsEventToState(GetPsyTestsEvent event) async* {
    try {
      yield PsyTestsLoading();

      var res = await ApiManager.psyTests(event.testCatId);
      if (res.code == ResponseCode.Success && res.psyTestList != null && res.psyTestList!.length > 0) {
        yield PsyTestsSuccess(res);
      } else {
        yield PsyTestsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield PsyTestsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestEvent extends Equatable {
  const PsyTestEvent();

  @override
  List<Object> get props => [];
}

class GetPsyTestsEvent extends PsyTestEvent {
  final int testCatId;

  const GetPsyTestsEvent(this.testCatId);

  @override
  List<Object> get props => [testCatId];

  @override
  String toString() => 'GetPsyTestsEvent { testCatId: $testCatId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestState extends Equatable {
  const PsyTestState();

  @override
  List<Object> get props => [];
}

class PsyTestsInit extends PsyTestState {}

class PsyTestsLoading extends PsyTestState {}

class PsyTestsSuccess extends PsyTestState {
  final PsyTestsResponse psyTestsResponse;

  const PsyTestsSuccess(this.psyTestsResponse);

  @override
  List<Object> get props => [psyTestsResponse];

  @override
  String toString() => 'PsyTestsSuccess { psyTestsResponse: $psyTestsResponse }';
}

class PsyTestsFailed extends PsyTestState {
  final String message;

  const PsyTestsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PsyTestsFailed { message: $message }';
}
