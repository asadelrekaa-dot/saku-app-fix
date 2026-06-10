import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SakuBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('[BLoC CREATE] ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[BLoC EVENT] ${bloc.runtimeType} <- $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('[BLoC CHANGE] ${bloc.runtimeType}: ${change.currentState.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('[BLoC TRANS] ${bloc.runtimeType}: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('[BLoC ERROR] ${bloc.runtimeType}: $error', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('[BLoC CLOSE] ${bloc.runtimeType}');
  }
}
