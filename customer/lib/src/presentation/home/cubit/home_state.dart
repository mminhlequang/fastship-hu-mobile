part of 'home_cubit.dart';

class HomeState extends Equatable {
  // Trạng thái loading
  final bool isLoading;
  // Thông báo lỗi (nếu có)
  final String? errorMessage;
  // Dữ liệu
  final List<dynamic>? banners;
  final List<CategoryModel>? categories;
  final List<ProductModel>? popularItems;
  final List<StoreModel>? stores;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.banners,
    this.categories,
    this.popularItems,
    this.stores,
  });

  // Helper để kiểm tra trạng thái
  bool get hasError => errorMessage != null;
  bool get hasData =>
      banners != null ||
      categories != null ||
      popularItems != null ||
      stores != null;

  // Tạo bản sao với các giá trị mới
  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<dynamic>? banners,
    List<CategoryModel>? categories,
    List<ProductModel>? popularItems,
    List<StoreModel>? stores,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      popularItems: popularItems ?? this.popularItems,
      stores: stores ?? this.stores,
    );
  }

  // Tạo trạng thái ban đầu
  factory HomeState.initial() {
    return const HomeState(
      isLoading: false,
      errorMessage: null,
      banners: null,
      categories: null,
      popularItems: null,
      stores: null,
    );
  }

  // Tạo trạng thái loading
  factory HomeState.loading() {
    return const HomeState(
      isLoading: true,
      errorMessage: null,
      banners: null,
      categories: null,
      popularItems: null,
      stores: null,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, banners, categories, popularItems, stores];
}
