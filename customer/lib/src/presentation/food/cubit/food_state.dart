part of 'food_cubit.dart';

sealed class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

final class FoodInitial extends FoodState {}

final class FoodLoading extends FoodState {}

final class FoodLoaded extends FoodState {
  final List<dynamic> foodItems;

  const FoodLoaded({this.foodItems = const []});

  @override
  List<Object> get props => [foodItems];
}

final class FoodError extends FoodState {
  final String message;

  const FoodError(this.message);

  @override
  List<Object> get props => [message];
}
