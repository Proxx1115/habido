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

class TestCategoryBloc extends Bloc<TestCategoryEvent, TestCategoryState> {
  TestCategoryBloc() : super(TestCategoryInit());

  @override
  Stream<TestCategoryState> mapEventToState(TestCategoryEvent event) async* {
    if (event is GetTestCategoriesEvent) {
      yield* _mapGetTestCategoriesEventToState();
    }
  }

  Stream<TestCategoryState> _mapGetTestCategoriesEventToState() async* {
    try {
      yield TestCategoryLoading();

      var res = await ApiManager.testCategories();
      if (res.code == ResponseCode.Success && res.testCategoryList != null && res.testCategoryList!.length > 0) {
        yield TestCategoriesSuccess(res.testCategoryList!);
      } else {
        yield TestCategoriesFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield TestCategoriesFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class TestCategoryEvent extends Equatable {
  const TestCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetTestCategoriesEvent extends TestCategoryEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class TestCategoryState extends Equatable {
  const TestCategoryState();

  @override
  List<Object> get props => [];
}

class TestCategoryInit extends TestCategoryState {}

class TestCategoryLoading extends TestCategoryState {}

class TestCategoriesSuccess extends TestCategoryState {
  final List<TestCategory> testCategoryList;

  const TestCategoriesSuccess(this.testCategoryList);

  @override
  List<Object> get props => [testCategoryList];

  @override
  String toString() => 'TestCategoriesSuccess { testCategoryList: $testCategoryList }';
}

class TestCategoriesFailed extends TestCategoryState {
  final String message;

  const TestCategoriesFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'TestCategoriesFailed { message: $message }';
}
