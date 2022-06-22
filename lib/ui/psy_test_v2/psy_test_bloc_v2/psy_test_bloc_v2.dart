import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test_review.dart';
import 'package:habido_app/models/test_info_result_response.dart';
import 'package:habido_app/models/test_name_with_tests.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class TestsBlocV2 extends Bloc<TestsEventV2, TestsStateV2> {
  TestsBlocV2() : super(ContentInitV2());

  @override
  Stream<TestsStateV2> mapEventToState(TestsEventV2 event) async* {
    if (event is GetTestListEvent) {
      yield* _mapGetTestEventToState();
    } else if (event is GetTestIntrolResultEvent) {
      yield* _mapGetTestIntrolResultState(event);
    } else if (event is TestReviewEvent) {
      yield* _mapTestReviewEventToState(event);
    }
  }

  Stream<TestsStateV2> _mapGetTestEventToState() async* {
    try {
      yield TestListLoading();

      var res = await ApiManager.psyTestList();
      // print("yelaData:${res.testNameWithTests}");
      if (res.code == ResponseCode.Success && res.testNameWithTests != null && res.testNameWithTests!.length > 0) {
        yield TestListSuccess(res.testNameWithTests!);
      } else {
        yield TestListEmpty();
      }
    } catch (e) {
      yield TestListFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<TestsStateV2> _mapGetTestIntrolResultState(GetTestIntrolResultEvent event) async* {
    try {
      yield TestIntrolResultLoading();

      var res = await ApiManager.psyTest(event.testId);
      if (res.code == ResponseCode.Success && res.testInfo != null) {
        yield TestIntrolResultSuccess(res);
      } else {
        yield TestIntrolResultEmpty();
      }
    } catch (e) {
      yield TestIntrolResultFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<TestsStateV2> _mapTestReviewEventToState(TestReviewEvent event) async* {
    try {
      yield TestReviewLoading();

      var res = await ApiManager.psyTestReview(event.psyTestReview);
      if (res.code == ResponseCode.Success) {
        // Refresh dashboard
        // BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

        yield TestReviewSuccess();
      } else {
        yield TestReviewFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield TestReviewFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class TestsEventV2 extends Equatable {
  const TestsEventV2();

  @override
  List<Object> get props => [];
}

class GetTestListEvent extends TestsEventV2 {}

class GetTestIntrolResultEvent extends TestsEventV2 {
  final int testId;

  const GetTestIntrolResultEvent(this.testId);

  @override
  List<Object> get props => [testId];

  @override
  String toString() => 'GetContentEvent { contentId: $testId }';
}

class TestReviewEvent extends TestsEventV2 {
  final PsyTestReview psyTestReview;

  const TestReviewEvent(this.psyTestReview);

  @override
  List<Object> get props => [psyTestReview];

  @override
  String toString() => 'PsyTestReview { psyTestReview: $psyTestReview }';
}

/// BLOC STATES
abstract class TestsStateV2 extends Equatable {
  const TestsStateV2();

  @override
  List<Object> get props => [];
}

class ContentInitV2 extends TestsStateV2 {}

/// TEST LIST STATES

class TestListLoading extends TestsStateV2 {}

class TestListEmpty extends TestsStateV2 {}

class TestListSuccess extends TestsStateV2 {
  final List<TestNameWithTests> testNameWithTests;

  const TestListSuccess(
    this.testNameWithTests,
  );

  @override
  List<Object> get props => [testNameWithTests];

  @override
  String toString() => 'ContentListSuccess { contentList: $testNameWithTests}';
}

class TestListFailed extends TestsStateV2 {
  final String message;

  const TestListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// TEST INTRO RESULT

class TestIntrolResultLoading extends TestsStateV2 {}

class TestIntrolResultEmpty extends TestsStateV2 {}

class TestIntrolResultSuccess extends TestsStateV2 {
  final TestInfoResultResponse testInfoResultResponse;

  const TestIntrolResultSuccess(
    this.testInfoResultResponse,
  );

  @override
  List<Object> get props => [testInfoResultResponse];

  @override
  String toString() => 'ContentListSuccess { contentList: $testInfoResultResponse}';
}

class TestIntrolResultFailed extends TestsStateV2 {
  final String message;

  const TestIntrolResultFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// TEST REVIEW

class TestReviewLoading extends TestsStateV2 {}

class TTestReviewEmpty extends TestsStateV2 {}

class TestReviewSuccess extends TestsStateV2 {}

class TestReviewFailed extends TestsStateV2 {
  final String message;

  const TestReviewFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
