part of 'food_detail_cubit.dart';

class FoodDetailState {
  final bool isLoading;
  final Map<String, dynamic>? foodDetail;
  final String error;

  FoodDetailState({
    required this.isLoading,
    this.foodDetail,
    required this.error,
  });

  factory FoodDetailState.initial() {
    return FoodDetailState(
      isLoading: false,
      foodDetail: null,
      error: '',
    );
  }

  FoodDetailState copyWith({
    bool? isLoading,
    Map<String, dynamic>? foodDetail,
    String? error,
  }) {
    return FoodDetailState(
      isLoading: isLoading ?? this.isLoading,
      foodDetail: foodDetail ?? this.foodDetail,
      error: error ?? this.error,
    );
  }
}
