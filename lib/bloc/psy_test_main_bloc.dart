import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test_results_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PsyTestMainBloc extends Bloc<PsyTestMainEvent, PsyTestMainState> {
  PsyTestMainBloc() : super(PsyTestMainInit());

  @override
  Stream<PsyTestMainState> mapEventToState(PsyTestMainEvent event) async* {
    if (event is GetPsyTestResultsEvent) {
      yield* _mapGetPsyTestResultsEventToState();
    }
  }

  Stream<PsyTestMainState> _mapGetPsyTestResultsEventToState() async* {
    try {
      yield PsyTestMainLoading();

      var res = await ApiManager.psyTestResults();
      if (res.code == ResponseCode.Success) {
        yield PsyTestResultsSuccess(res);
      } else {
        // yield PsyTestResultsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield PsyTestResultsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestMainEvent extends Equatable {
  const PsyTestMainEvent();

  @override
  List<Object> get props => [];
}

class GetPsyTestResultsEvent extends PsyTestMainEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestMainState extends Equatable {
  const PsyTestMainState();

  @override
  List<Object> get props => [];
}

class PsyTestMainInit extends PsyTestMainState {}

class PsyTestMainLoading extends PsyTestMainState {}

class PsyTestResultsSuccess extends PsyTestMainState {
  final PsyTestResultsResponse response;

  const PsyTestResultsSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'PsyTestResultsSuccess { response: $response }';
}

class PsyTestResultsFailed extends PsyTestMainState {
  final String message;

  const PsyTestResultsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PsyTestResultsFailed { message: $message }';
}
