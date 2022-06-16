import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
}

/// BLOC EVENTS
abstract class TestsEventV2 extends Equatable {
  const TestsEventV2();

  @override
  List<Object> get props => [];
}

class GetTestListEvent extends TestsEventV2 {}

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
