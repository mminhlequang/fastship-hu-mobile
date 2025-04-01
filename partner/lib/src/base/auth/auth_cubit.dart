import 'dart:async';

import 'package:network_resources/auth/models/models.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/store/repo.dart';
import 'package:network_resources/transaction/models/models.dart';
import 'package:network_resources/transaction/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_network/network_resources/resources.dart';

enum AuthStateType { none, logged }

AuthCubit get authCubit => findInstance<AuthCubit>();

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  int get storeId => state.store?.id ?? 0;

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
      clearAllRouters('/merchant-onboarding');
    }
  }

  setStore(StoreModel store, {bool refresh = false}) {
    state.store = store;
    if (refresh) {
      refreshStore();
    } else {
      emit(state.update());
    }
  }

  refreshStore() async {
    NetworkResponse response = await StoreRepo().getStoreDetail({
      "id": state.store!.id,
    });
    if (response.isSuccess) {
      state.store = response.data;
    }
    emit(state.update());
  }

  logout() async {
    AppPrefs.instance.clear();
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
  StoreModel? store;

  AuthState({
    this.stateType = AuthStateType.none,
    this.user,
    this.wallet,
    this.stores,
    this.store,
  });

  AuthState update({
    AuthStateType? stateType,
    AccountModel? user,
    MyWallet? wallet,
    List<StoreModel>? stores,
    StoreModel? store,
  }) {
    return AuthState(
      stateType: stateType ?? this.stateType,
      user: user ?? this.user,
      wallet: wallet ?? this.wallet,
      stores: stores ?? this.stores,
      store: store ?? this.store,
    );
  }
}
