import 'package:bloc/bloc.dart';
import 'package:app/src/utils/utils.dart';

part 'food_detail_state.dart';

FoodDetailCubit get foodDetailCubit => findInstance<FoodDetailCubit>();

class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit() : super(FoodDetailState.initial());

  void getFoodDetail(String foodId) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Mô phỏng gọi API để lấy thông tin chi tiết món ăn
      await Future.delayed(const Duration(seconds: 1));

      // Dữ liệu mẫu
      final foodDetail = {
        'id': foodId,
        'name': 'Blueberry Pancake Special',
        'image': 'assets/images/pancake.png',
        'description':
            'Delicious homemade pancakes with fresh blueberries, maple syrup, and whipped cream.',
        'price': 9.20,
        'discountPrice': 4.50,
        'rating': 4.8,
        'reviews': 250,
        'restaurant': {
          'id': 'rest1',
          'name': 'Breakfast Paradise',
          'distance': '1.2km',
        },
        'ingredients': [
          'Flour',
          'Eggs',
          'Milk',
          'Blueberries',
          'Sugar',
          'Butter'
        ],
        'nutrition': {'calories': 450, 'proteins': 12, 'carbs': 65, 'fats': 18}
      };

      emit(state.copyWith(
        isLoading: false,
        foodDetail: foodDetail,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Không thể tải thông tin món ăn: ${e.toString()}',
      ));
    }
  }

  void updateFavorite() {
    final currentDetail = Map<String, dynamic>.from(state.foodDetail ?? {});
    currentDetail['isFavorite'] = !(currentDetail['isFavorite'] ?? false);

    emit(state.copyWith(foodDetail: currentDetail));
  }

  void updateQuantity(int quantity) {
    if (quantity < 1) return;

    final currentDetail = Map<String, dynamic>.from(state.foodDetail ?? {});
    currentDetail['quantity'] = quantity;

    emit(state.copyWith(foodDetail: currentDetail));
  }
}
