part of 'account_cubit.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class AccountLoading extends AccountState {}

final class AccountLoaded extends AccountState {
  final Map<String, dynamic> userData;

  const AccountLoaded({this.userData = const {}});

  @override
  List<Object> get props => [userData];
}

final class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}
