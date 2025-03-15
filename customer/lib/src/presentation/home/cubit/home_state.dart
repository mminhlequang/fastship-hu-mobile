part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Banner> banners;
  final List<Category> categories;
  final List<Food> popularItems;
  final List<Shop> shops;

  const HomeLoaded({
    this.banners = const [],
    this.categories = const [],
    this.popularItems = const [],
    this.shops = const [],
  });

  @override
  List<Object> get props => [banners, categories, popularItems, shops];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
