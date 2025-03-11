import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/reviews_cubit.dart';
import 'widgets/widgets.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewsCubit()..loadReviews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đánh giá'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state.status == ReviewsStatus.initial) {
              return const SizedBox();
            }

            if (state.status == ReviewsStatus.loading) {
              return _buildLoadingState();
            }

            if (state.status == ReviewsStatus.error) {
              return _buildErrorState(state.errorMessage);
            }

            return _buildLoadedState(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải đánh giá...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, ReviewsState state) {
    final cubit = context.read<ReviewsCubit>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              RatingHeader(
                restaurantRating: state.restaurantRating,
                foodRating: state.foodRating,
                reviewsCount: state.reviewsCount,
                lastReviewTime: '7 ngày trước',
              ),
              FilterBar(
                selectedDay: state.filterDay,
                selectedStar: state.filterStar,
                selectedComment: state.filterComment,
                onDaySelected: (day) => cubit.updateFilter(day: day),
                onStarSelected: (star) => cubit.updateFilter(star: star),
                onCommentSelected: (comment) =>
                    cubit.updateFilter(comment: comment),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final review = state.reviews[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ReviewItem(review: review),
              );
            },
            childCount: state.reviews.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }
}
