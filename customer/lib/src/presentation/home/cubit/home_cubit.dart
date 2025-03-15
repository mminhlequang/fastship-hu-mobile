import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/network_resources/common/model/banner.dart';
import 'package:app/src/network_resources/common/model/category.dart';
import 'package:app/src/network_resources/common/model/shop.dart';
import 'package:app/src/network_resources/common/model/food.dart';
import 'package:app/src/network_resources/common/repo.dart';

part 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Thêm các hàm xử lý logic cho màn hình Home
  void fetchHomeData() async {
    emit(HomeLoading());

    try {
      final repo = CommonRepo();

      // Gọi API để lấy dữ liệu
      final categories = await repo.getCategories() ?? [];
      final shops = await repo.getShops() ?? [];
      final foods = await repo.getFoods() ?? [];
      final banners = await repo.getBanners() ?? [];

      // Lọc các món ăn phổ biến
      final popularItems =
          foods.where((food) => food.isPopular == true).toList();

      emit(HomeLoaded(
        categories: categories,
        shops: shops,
        popularItems: popularItems,
        banners: banners,
      ));
    } catch (e) {
      emit(HomeError('Không thể tải dữ liệu: ${e.toString()}'));
    }
  }

  void refreshHomeData() {
    fetchHomeData();
  }
}
