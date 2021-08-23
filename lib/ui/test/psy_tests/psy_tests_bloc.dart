import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/models/test_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PsyTestsBloc extends Bloc<PsyTestsEvent, PsyTestsState> {
  PsyTestsBloc() : super(PsyTestsInit());

  @override
  Stream<PsyTestsState> mapEventToState(PsyTestsEvent event) async* {
    if (event is GetPsyTestsEvent) {
      yield* _mapGetPsyTestsEventToState(event);
    }
  }

  Stream<PsyTestsState> _mapGetPsyTestsEventToState(GetPsyTestsEvent event) async* {
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

abstract class PsyTestsEvent extends Equatable {
  const PsyTestsEvent();

  @override
  List<Object> get props => [];
}

class GetPsyTestsEvent extends PsyTestsEvent {
  final int testCatId;

  const GetPsyTestsEvent(this.testCatId);

  @override
  List<Object> get props => [testCatId];

  @override
  String toString() => 'GetCategoryTestsEvent { testCatId: $testCatId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestsState extends Equatable {
  const PsyTestsState();

  @override
  List<Object> get props => [];
}

class PsyTestsInit extends PsyTestsState {}

class PsyTestsLoading extends PsyTestsState {}

class PsyTestsSuccess extends PsyTestsState {
  final PsyTestsResponse psyTestsResponse;

  const PsyTestsSuccess(this.psyTestsResponse);

  @override
  List<Object> get props => [psyTestsResponse];

  @override
  String toString() => 'PsyTestsSuccess { psyTestsResponse: $psyTestsResponse }';
}

class PsyTestsFailed extends PsyTestsState {
  final String message;

  const PsyTestsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PsyTestsFailed { message: $message }';
}
