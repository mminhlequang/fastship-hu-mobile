import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit() : super(const ReviewsState());

  Future<void> loadReviews() async {
    emit(state.copyWith(status: ReviewsStatus.loading));

    try {
      // Giả lập thời gian tải dữ liệu
      await Future.delayed(const Duration(seconds: 2));

      // Tạo dữ liệu giả
      final mockReviews = _generateMockReviews();

      emit(state.copyWith(
        status: ReviewsStatus.loaded,
        reviews: mockReviews,
        restaurantRating: 4.8,
        foodRating: 4.8,
        reviewsCount: 456,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReviewsStatus.error,
        errorMessage: 'Có lỗi xảy ra khi tải đánh giá: ${e.toString()}',
      ));
    }
  }

  void updateFilter({String? day, String? star, String? comment}) {
    emit(state.copyWith(
      filterDay: day ?? state.filterDay,
      filterStar: star ?? state.filterStar,
      filterComment: comment ?? state.filterComment,
    ));
  }

  // Tạo dữ liệu giả để demo
  List<Review> _generateMockReviews() {
    final reviews = <Review>[];

    reviews.add(
      Review(
        id: '1',
        userName: 'User12345',
        userAvatar: 'https://randomuser.me/api/portraits/men/32.jpg',
        userPhone: '#2345987654',
        rating: 4.0,
        date: '24/02/2025 11:11',
        comment:
            'Khách comment Lorem ipsum dolor sit amet consec tetur. Duis vel libero sed rutrum.',
        foodImage: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
        merchantReply: MerchantReply(
          merchantName: 'Merchant123',
          date: '24/02/2025 11:11',
          comment:
              'Lorem ipsum dolor sit amet consectetur. Euismod cras erat lectus est elit viverra integer hac at. A orci semper mauris proin. Ut tortor maecenas ur...',
        ),
      ),
    );

    reviews.add(
      Review(
        id: '2',
        userName: 'User678',
        userAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
        userPhone: '#2345987654',
        rating: 4.0,
        date: '24/02/2025 11:11',
        comment: 'Đồ ăn rất ngon, dịch vụ nhanh. Tôi sẽ quay lại lần sau.',
      ),
    );

    reviews.add(
      Review(
        id: '3',
        userName: 'User12345',
        userAvatar: 'https://randomuser.me/api/portraits/women/32.jpg',
        userPhone: '#2345987654',
        rating: 4.0,
        date: '24/02/2025 11:11',
        comment: 'Nhà hàng sạch sẽ, không gian thoáng mát. Thức ăn tươi ngon.',
      ),
    );

    return reviews;
  }
}
