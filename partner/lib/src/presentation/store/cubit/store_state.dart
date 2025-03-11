part of 'store_cubit.dart';

class StoreState extends Equatable {
  final bool hasStore;

  const StoreState({this.hasStore = false});

  @override
  List<Object> get props => [hasStore];
}
