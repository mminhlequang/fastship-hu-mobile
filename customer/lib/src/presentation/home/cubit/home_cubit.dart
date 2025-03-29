import 'package:app/src/network_resources/category/model/category.dart';
import 'package:app/src/network_resources/category/repo.dart';
import 'package:app/src/network_resources/store/models/models.dart'; 
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  // Hàm xử lý logic lấy dữ liệu cho màn hình Home
  void fetchHomeData() async {
    // Đặt trạng thái loading
    emit(HomeState.loading());

    try {

      final categories = await CategoryRepo().getCategories();
       
      // Cập nhật state với dữ liệu mới, không còn loading
      emit(HomeState(
        isLoading: false,
        categories: categories,
      ));

      // final categories = await CategoryRepo().getCategories();
      // final stores = await StoreRepo().getStores();
      // final products = await ProductRepo().getProducts();
      // final banners = await CommonRepo().getBanners();

      // // Lọc các món ăn phổ biến
      // final popularItems =
      //     products?.where((product) => product.isPopular == true).toList();

      // // Cập nhật state với dữ liệu mới, không còn loading
      // emit(HomeState(
      //   isLoading: false,
      //   banners: banners,
      //   categories: categories,
      //   popularItems: popularItems,
      //   stores: stores,
      // ));
    } catch (e) {
      // Cập nhật state với thông báo lỗi
      emit(HomeState(
        isLoading: false,
        errorMessage: 'Không thể tải dữ liệu: ${e.toString()}',
      ));
    }
  }

  void refreshHomeData() {
    fetchHomeData();
  }
}
