import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test_results_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PsyTestDashBoardBloc extends Bloc<PsyTestDashboardEvent, PsyTestDashboardState> {
  PsyTestDashBoardBloc() : super(PsyTestDashboardInit());

  @override
  Stream<PsyTestDashboardState> mapEventToState(PsyTestDashboardEvent event) async* {
    if (event is GetPsyTestResultsEvent) {
      yield* _mapGetPsyTestResultsEventToState();
    }
  }

  Stream<PsyTestDashboardState> _mapGetPsyTestResultsEventToState() async* {
    try {
      yield PsyTestDashboardLoading();

      var res = await ApiManager.psyTestUserResults();
      if (res.code == ResponseCode.Success) {
        yield PsyUserTestResultsSuccess(res);
      } else {
        // yield PsyTestResultsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield PsyUserTestResultsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestDashboardEvent extends Equatable {
  const PsyTestDashboardEvent();

  @override
  List<Object> get props => [];
}

class GetPsyUserTestResultsEvent extends PsyTestDashboardEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestDashboardState extends Equatable {
  const PsyTestDashboardState();

  @override
  List<Object> get props => [];
}

class PsyTestDashboardInit extends PsyTestDashboardState {}

class PsyTestDashboardLoading extends PsyTestDashboardState {}

class PsyUserTestResultsSuccess extends PsyTestDashboardState {
  final PsyTestResultsResponse response;

  const PsyUserTestResultsSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'PsyTestResultsSuccess { response: $response }';
}

class PsyUserTestResultsFailed extends PsyTestDashboardState {
  final String message;

  const PsyUserTestResultsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PsyTestResultsFailed { message: $message }';
}
