import 'dart:async';

import 'package:app/src/network_resources/auth/models/models.dart';
import 'package:app/src/network_resources/auth/repo.dart';
import 'package:app/src/network_resources/store/models/models.dart';
import 'package:app/src/network_resources/store/repo.dart';
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

      await fetchStores();
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

  fetchStores({bool isRedirect = false}) async {
    NetworkResponse response = await StoreRepo().getMyStores({});
    if (response.isSuccess) {
      state.stores = response.data;
      emit(state.update());
    }
    if (isRedirect) {
      appContext.pushReplacement('/merchant-onboarding');
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
    List<StoreModel> myStores = state.stores ?? [];
    if (state.stateType == AuthStateType.logged) {
      if (myStores.isNotEmpty) {
        appContext.pushReplacement('/merchant-onboarding');
      } else {
        appContext.pushReplacement('/store-registration');
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
  List<StoreModel>? stores;

  AuthState({
    this.stateType = AuthStateType.none,
    this.user,
    this.wallet,
    this.stores,
  });

  AuthState update({
    AuthStateType? stateType,
    AccountModel? user,
    MyWallet? wallet,
    List<StoreModel>? stores,
  }) {
    return AuthState(
      stateType: stateType ?? this.stateType,
      user: user ?? this.user,
      wallet: wallet ?? this.wallet,
      stores: stores ?? this.stores,
    );
  }
}
