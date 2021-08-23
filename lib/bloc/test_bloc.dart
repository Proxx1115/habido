import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/test_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestInit());

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is GetTestCategoriesEvent) {
      yield* _mapGetTestCategoriesEventToState();
    }
  }

  Stream<TestState> _mapGetTestCategoriesEventToState() async* {
    try {
      yield TestLoading();

      var res = await ApiManager.testCategories();
      if (res.code == ResponseCode.Success && res.testCategoryList != null && res.testCategoryList!.length > 0) {
        yield TestCategorySuccess(res.testCategoryList!);
      } else {
        yield TestCategoryFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield TestCategoryFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object> get props => [];
}

class GetTestCategoriesEvent extends TestEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object> get props => [];
}

class TestInit extends TestState {}

class TestLoading extends TestState {}

class TestCategorySuccess extends TestState {
  final List<TestCategory> testCategoryList;

  const TestCategorySuccess(this.testCategoryList);

  @override
  List<Object> get props => [testCategoryList];

  @override
  String toString() => 'TestCategorySuccess { testCategoryList: $testCategoryList }';
}

class TestCategoryFailed extends TestState {
  final String message;

  const TestCategoryFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'TestCategoryFailed { message: $message }';
}
