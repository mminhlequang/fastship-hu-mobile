import 'dart:async';

import 'package:app/src/network_resources/auth/models/models.dart';
import 'package:app/src/network_resources/auth/repo.dart';
import 'package:app/src/network_resources/transaction/models/models.dart';
import 'package:app/src/network_resources/transaction/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_network/network_resources/resources.dart';

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
      fetchWallet();
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

  fetchWallet() async {
    NetworkResponse response = await TransactionRepo().getMyWallet({
      "currency": AppPrefs.instance.currency,
    });
    if (response.isSuccess) {
      state.wallet = response.data;
      emit(state.update());
    }
  }

  logout() async {
    AppPrefs.instance.clear();
    _subscription?.cancel();
    try {
      emit(state.update(stateType: AuthStateType.none));
      _redirect();
    } catch (e) {}
  }

  _redirect() {
    if (state.stateType == AuthStateType.logged) {
      appContext.pushReplacement('/order-detail');
      return;
      if ((AppPrefs.instance.user!.profile!.stepId ?? 1) < 5) {
        appContext.pushReplacement('/driver-register');
      } else {
        appContext.pushReplacement('/home');
      }
    } else {
      appContext.pushReplacement('/auth');
    }
  }
}

class AuthState {
  AuthStateType stateType;
  AccountModel? user;

  MyWallet? wallet;

  AuthState({
    this.stateType = AuthStateType.none,
    this.user,
    this.wallet,
  });

  AuthState update({
    AuthStateType? stateType,
    AccountModel? user,
    MyWallet? wallet,
  }) {
    return AuthState(
      stateType: stateType ?? this.stateType,
      user: user ?? this.user,
      wallet: wallet ?? this.wallet,
    );
  }
}
