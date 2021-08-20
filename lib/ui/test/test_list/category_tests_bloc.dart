import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/test_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class CategoryTestsBloc extends Bloc<CategoryTestsEvent, CategoryTestsState> {
  CategoryTestsBloc() : super(CategoryTestsInit());

  @override
  Stream<CategoryTestsState> mapEventToState(CategoryTestsEvent event) async* {
    if (event is GetCategoryTestsEvent) {
      yield* _mapGetCategoryTestsEventToState();
    }
  }

  Stream<CategoryTestsState> _mapGetCategoryTestsEventToState() async* {
    try {
      yield CategoryTestsLoading();

      var res = await ApiManager.testCategories();
      if (res.code == ResponseCode.Success && res.testCategoryList != null && res.testCategoryList!.length > 0) {
        yield TestCategoriesSuccess(res.testCategoryList!);
      } else {
        yield TestCategoriesFailed(res.message ?? LocaleKeys.noData);
      }
    } catch (e) {
      yield TestCategoriesFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CategoryTestsEvent extends Equatable {
  const CategoryTestsEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryTestsEvent extends CategoryTestsEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CategoryTestsState extends Equatable {
  const CategoryTestsState();

  @override
  List<Object> get props => [];
}

class CategoryTestsInit extends CategoryTestsState {}

class CategoryTestsLoading extends CategoryTestsState {}

class TestCategoriesSuccess extends CategoryTestsState {
  final List<TestCategory> testCategoryList;

  const TestCategoriesSuccess(this.testCategoryList);

  @override
  List<Object> get props => [testCategoryList];

  @override
  String toString() => 'TestCategoriesSuccess { testCategoryList: $testCategoryList }';
}

class TestCategoriesFailed extends CategoryTestsState {
  final String message;

  const TestCategoriesFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'TestCategoriesFailed { message: $message }';
}
