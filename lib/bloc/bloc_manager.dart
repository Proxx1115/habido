import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/main_bloc.dart';

import 'auth_bloc.dart';

class BlocManager {
  static final MainBloc mainBloc = MainBloc();
  static final AuthBloc authBloc = AuthBloc();

  static void dispose() {
    mainBloc.close();
    authBloc.close();
  }
}

/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final MainBloc mainBloc;

  LifecycleEventHandler(this.mainBloc);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        onPaused();
        break;
      case AppLifecycleState.resumed:
        onResume();
        break;
    }
  }

  void onResume() {}

  void onResumeDone(bool done) {}

  void onPaused() {}
}
