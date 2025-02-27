import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/src/utils/utils.dart';
import 'package:go_router/go_router.dart';

enum AuthStateType { none, logged }

AuthCubit get authCubit => findInstance<AuthCubit>();

class AuthCubit extends Cubit<AuthState> {
  StreamSubscription? _subscription;

  AuthCubit() : super(AuthState());
  update(user) async {
    state.user = user;
    emit(state.update());
    // if (state.user == null) {
    //   add(LogoutAuthEvent());
    // }
  }

  load({Duration delayRedirect = const Duration(seconds: 3)}) async {
    try {
      emit(state.update(stateType: AuthStateType.logged));
    } catch (e) {
      emit(state.update(stateType: AuthStateType.none));
    }
    if (state.stateType == AuthStateType.logged) {
      // state.user = user;
      // _subscription?.cancel();
      // _subscription =
      //     FirebaseAuth.instance.authStateChanges().listen((User? user) {
      //   add(AuthUpdateUser(user: user));
      // });
    }

    await Future.delayed(delayRedirect);
    _redirect();
  }

  logout() async {
    _subscription?.cancel();
    try {
      emit(state.update(stateType: AuthStateType.none));
      _redirect();
    } catch (e) {}
  }

  _redirect() {
    if (state.stateType == AuthStateType.logged) {
      appContext.pushReplacement('/home');
    } else {
      appContext.pushReplacement('/auth');
    }
  }
}

class AuthState {
  AuthStateType stateType;
  dynamic user;

  AuthState({
    this.stateType = AuthStateType.none,
    this.user,
  });

  AuthState update({AuthStateType? stateType, dynamic user}) {
    return AuthState(
      stateType: stateType ?? this.stateType,
      user: user ?? this.user,
    );
  }
}
