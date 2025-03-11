import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/utils/utils.dart';

part 'food_state.dart';

FoodCubit get foodCubit => findInstance<FoodCubit>();

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodInitial());

  // Thêm các hàm xử lý logic cho màn hình Food
  void fetchFoodData() {
    emit(FoodLoading());

    // TODO: Gọi API hoặc lấy dữ liệu từ local
    // Giả lập dữ liệu thành công
    emit(FoodLoaded());
  }
}
