part of 'reviews_cubit.dart';

enum ReviewsStatus { initial, loading, loaded, error }

class ReviewsState extends Equatable {
  final ReviewsStatus status;
  final List<Review> reviews;
  final String errorMessage;
  final double restaurantRating;
  final double foodRating;
  final int reviewsCount;
  final String filterDay;
  final String filterStar;
  final String filterComment;

  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.reviews = const [],
    this.errorMessage = '',
    this.restaurantRating = 0.0,
    this.foodRating = 0.0,
    this.reviewsCount = 0,
    this.filterDay = '7 days ago',
    this.filterStar = '5 Star',
    this.filterComment = 'Comment',
  });

  ReviewsState copyWith({
    ReviewsStatus? status,
    List<Review>? reviews,
    String? errorMessage,
    double? restaurantRating,
    double? foodRating,
    int? reviewsCount,
    String? filterDay,
    String? filterStar,
    String? filterComment,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage ?? this.errorMessage,
      restaurantRating: restaurantRating ?? this.restaurantRating,
      foodRating: foodRating ?? this.foodRating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      filterDay: filterDay ?? this.filterDay,
      filterStar: filterStar ?? this.filterStar,
      filterComment: filterComment ?? this.filterComment,
    );
  }

  @override
  List<Object> get props => [
        status,
        reviews,
        errorMessage,
        restaurantRating,
        foodRating,
        reviewsCount,
        filterDay,
        filterStar,
        filterComment,
      ];
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final String userPhone;
  final double rating;
  final String date;
  final String comment;
  final MerchantReply? merchantReply;
  final String? foodImage;

  Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.userPhone,
    required this.rating,
    required this.date,
    required this.comment,
    this.merchantReply,
    this.foodImage,
  });
}

class MerchantReply {
  final String merchantName;
  final String date;
  final String comment;

  MerchantReply({
    required this.merchantName,
    required this.date,
    required this.comment,
  });
}
