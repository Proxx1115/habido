import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_category.dart';
import 'package:habido_app/models/psy_test_questions_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PsyTestBloc extends Bloc<PsyTestEvent, PsyTestState> {
  PsyTestBloc() : super(PsyTestInit());

  @override
  Stream<PsyTestState> mapEventToState(PsyTestEvent event) async* {
    if (event is GetPsyTestQuestionsEvent) {
      yield* _mapGetPsyTestQuestionsEventToState(event);
    }
  }

  Stream<PsyTestState> _mapGetPsyTestQuestionsEventToState(GetPsyTestQuestionsEvent event) async* {
    try {
      yield PsyTestLoading();

      var res = await ApiManager.psyTestQuestions(event.testId);
      if (res.code == ResponseCode.Success && res.questionList != null && res.questionList!.isNotEmpty) {
        yield PsyQuestionsSuccess(res);
      } else {
        yield PsyQuestionsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield PsyQuestionsFailed(LocaleKeys.errorOccurred);
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

class GetPsyTestQuestionsEvent extends PsyTestEvent {
  final int testId;

  const GetPsyTestQuestionsEvent(this.testId);

  @override
  List<Object> get props => [testId];

  @override
  String toString() => 'GetPsyTestQuestionsEvent { testId: $testId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyTestState extends Equatable {
  const PsyTestState();

  @override
  List<Object> get props => [];
}

class PsyTestInit extends PsyTestState {}

class PsyTestLoading extends PsyTestState {}

class PsyQuestionsSuccess extends PsyTestState {
  final PsyTestQuestionsResponse response;

  const PsyQuestionsSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'PsyQuestionsSuccess { response: $response }';
}

class PsyQuestionsFailed extends PsyTestState {
  final String message;

  const PsyQuestionsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PsyQuestionsFailed { message: $message }';
}
