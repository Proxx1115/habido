import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PsyCategoryBloc extends Bloc<PsyCategoryEvent, PsyCategoryState> {
  PsyCategoryBloc() : super(PsyCategoryInit());

  @override
  Stream<PsyCategoryState> mapEventToState(PsyCategoryEvent event) async* {
    if (event is GetPsyCategoriesEvent) {
      yield* _mapGetPsyCategoriesEventToState();
    }
  }

  Stream<PsyCategoryState> _mapGetPsyCategoriesEventToState() async* {
    try {
      yield PsyCategoryLoading();

      var res = await ApiManager.psyCategories();
      if (res.code == ResponseCode.Success && res.psyCategoryList != null && res.psyCategoryList!.length > 0) {
        yield PsyCategoriesSuccess(res.psyCategoryList!);
      } else {
        yield PsyCategoriesFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield PsyCategoriesFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyCategoryEvent extends Equatable {
  const PsyCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetPsyCategoriesEvent extends PsyCategoryEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PsyCategoryState extends Equatable {
  const PsyCategoryState();

  @override
  List<Object> get props => [];
}

class PsyCategoryInit extends PsyCategoryState {}

class PsyCategoryLoading extends PsyCategoryState {}

class PsyCategoriesSuccess extends PsyCategoryState {
  final List<PsyCategory> psyCategoryList;

  const PsyCategoriesSuccess(this.psyCategoryList);

  @override
  List<Object> get props => [psyCategoryList];

  @override
  String toString() => 'PsyCategoriesSuccess { psyCategoryList: $psyCategoryList }';
}

class PsyCategoriesFailed extends PsyCategoryState {
  final String message;

  const PsyCategoriesFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PsyCategoriesFailed { message: $message }';
}
