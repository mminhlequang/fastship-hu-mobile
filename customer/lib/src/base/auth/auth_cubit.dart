import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_network/network_resources/model/model.dart';
import 'package:network_resources/auth/models/models.dart';
import 'package:network_resources/auth/repo.dart';

enum AuthStateType { none, logged }

AuthCubit get authCubit => findInstance<AuthCubit>();

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  bool get isLoggedIn => state.stateType == AuthStateType.logged;

  update(user) async {
    state.user = user;
    emit(state.update());
    // if (state.user == null) {
    //   add(LogoutAuthEvent());
    // }
  }

  load({
    Duration delayRedirect = const Duration(seconds: 1),
    AccountModel? user,
  }) async {
    try {
      if (user != null) {
        state.user = user;
        AppPrefs.instance.user = user;
        emit(state.update(stateType: AuthStateType.logged));
      } else {
        NetworkResponse response = await AuthRepo().getProfile();
        if (response.isSuccess) {
          state.user = response.data;
          AppPrefs.instance.user = response.data;
          emit(state.update(stateType: AuthStateType.logged));
        } else {
          emit(state.update(stateType: AuthStateType.none));
        }
      }
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
    try {
      AppPrefs.instance.clear();
    } catch (_) {}
    emit(state.update(stateType: AuthStateType.none));
    _redirect();
  }

  _redirect() {
    appContext.pushReplacement("/navigation");
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
