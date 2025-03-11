part of 'restaurant_detail_cubit.dart';

class RestaurantDetailState {
  final bool isLoading;
  final Map<String, dynamic>? restaurantDetail;
  final String error;
  final int selectedTabIndex;

  RestaurantDetailState({
    required this.isLoading,
    this.restaurantDetail,
    required this.error,
    required this.selectedTabIndex,
  });

  factory RestaurantDetailState.initial() {
    return RestaurantDetailState(
      isLoading: false,
      restaurantDetail: null,
      error: '',
      selectedTabIndex: 0,
    );
  }

  RestaurantDetailState copyWith({
    bool? isLoading,
    Map<String, dynamic>? restaurantDetail,
    String? error,
    int? selectedTabIndex,
  }) {
    return RestaurantDetailState(
      isLoading: isLoading ?? this.isLoading,
      restaurantDetail: restaurantDetail ?? this.restaurantDetail,
      error: error ?? this.error,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}
