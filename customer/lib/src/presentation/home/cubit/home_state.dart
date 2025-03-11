part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<dynamic> banners;
  final List<dynamic> categories;
  final List<dynamic> popularItems;

  const HomeLoaded({
    this.banners = const [],
    this.categories = const [],
    this.popularItems = const [],
  });

  @override
  List<Object> get props => [banners, categories, popularItems];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
