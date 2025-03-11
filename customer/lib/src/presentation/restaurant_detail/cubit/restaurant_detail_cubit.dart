import 'package:bloc/bloc.dart';
import 'package:app/src/utils/utils.dart';

part 'restaurant_detail_state.dart';

RestaurantDetailCubit get restaurantDetailCubit =>
    findInstance<RestaurantDetailCubit>();

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  RestaurantDetailCubit() : super(RestaurantDetailState.initial());

  void getRestaurantDetail(String restaurantId) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Mô phỏng gọi API để lấy thông tin chi tiết nhà hàng
      await Future.delayed(const Duration(seconds: 1));

      // Dữ liệu mẫu
      final restaurantDetail = {
        'id': restaurantId,
        'name': 'Chef Burgers London',
        'image': 'assets/images/chef_burger.png',
        'coverImage': 'assets/images/restaurant_cover.png',
        'logo': 'assets/images/restaurant_logo.png',
        'description':
            'Nhà hàng chuyên phục vụ các loại burger thơm ngon, đặc biệt là các món ăn đặc trưng được chế biến bởi đầu bếp nổi tiếng.',
        'rating': 5.0,
        'reviewCount': 1250,
        'priceRange': '₫₫',
        'distance': '1.2km',
        'openingHours': '08:00 - 22:00',
        'location': '123 Regent Street, London',
        'phone': '+44 123 456 789',
        'categories': ['Burger', 'Fast Food', 'Western'],
        'isFavorite': false,
        'foodItems': [
          {
            'id': 'food1',
            'name': 'Classic Cheeseburger',
            'image': 'assets/images/cheeseburger.png',
            'price': 8.50,
            'discountPrice': 6.99,
            'rating': 4.8,
            'reviewCount': 350,
            'isFavorite': false,
            'isPopular': true,
          },
          {
            'id': 'food2',
            'name': 'Chicken Burger Special',
            'image': 'assets/images/chickenburger.png',
            'price': 9.20,
            'discountPrice': 7.50,
            'rating': 4.7,
            'reviewCount': 280,
            'isFavorite': false,
            'isPopular': true,
          },
          {
            'id': 'food3',
            'name': 'Veggie Burger',
            'image': 'assets/images/veggieburger.png',
            'price': 7.80,
            'discountPrice': 6.50,
            'rating': 4.5,
            'reviewCount': 210,
            'isFavorite': false,
            'isPopular': false,
          },
          {
            'id': 'food4',
            'name': 'Double Decker Burger',
            'image': 'assets/images/doubleburger.png',
            'price': 11.50,
            'discountPrice': 9.99,
            'rating': 4.9,
            'reviewCount': 420,
            'isFavorite': false,
            'isPopular': true,
          }
        ]
      };

      emit(state.copyWith(
        isLoading: false,
        restaurantDetail: restaurantDetail,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Không thể tải thông tin nhà hàng: ${e.toString()}',
      ));
    }
  }

  void updateFavorite() {
    final currentDetail =
        Map<String, dynamic>.from(state.restaurantDetail ?? {});
    currentDetail['isFavorite'] = !(currentDetail['isFavorite'] ?? false);

    emit(state.copyWith(restaurantDetail: currentDetail));
  }

  void toggleFoodFavorite(String foodId) {
    final currentDetail =
        Map<String, dynamic>.from(state.restaurantDetail ?? {});
    final List<dynamic> foodItems = List.from(currentDetail['foodItems'] ?? []);

    for (int i = 0; i < foodItems.length; i++) {
      if (foodItems[i]['id'] == foodId) {
        foodItems[i] = Map<String, dynamic>.from(foodItems[i]);
        foodItems[i]['isFavorite'] = !(foodItems[i]['isFavorite'] ?? false);
        break;
      }
    }

    currentDetail['foodItems'] = foodItems;
    emit(state.copyWith(restaurantDetail: currentDetail));
  }

  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
