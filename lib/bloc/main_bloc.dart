import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(AppInit());

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is InitEvent) {
      yield* _mapInitEventToState();
    }
  }

  Stream<MainState> _mapInitEventToState() async* {
    customColors = CustomColors.light();
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends MainEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class AppInit extends MainState {}
