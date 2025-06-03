import 'package:flutter/material.dart';
import 'package:app/src/presentation/report/cubit/report_cubit.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';

class CustomerReviewsWidget extends StatefulWidget {
  final List<CustomerReview> reviews;

  const CustomerReviewsWidget({
    super.key,
    required this.reviews,
  });

  @override
  State<CustomerReviewsWidget> createState() => _CustomerReviewsWidgetState();
}

class _CustomerReviewsWidgetState extends State<CustomerReviewsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: hexColor('#FFD700'),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Reviews',
                  style: w600TextStyle(fontSize: 18),
                ),
                const Spacer(),
                _buildAverageRating(),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: PageView.builder(
                itemCount: widget.reviews.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _animationController,
                        child: _buildReviewCard(widget.reviews[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageRating() {
    final avgRating = widget.reviews.isEmpty
        ? 0.0
        : widget.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            widget.reviews.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: hexColor('#FFD700').withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 16,
            color: hexColor('#FFD700'),
          ),
          const SizedBox(width: 4),
          Text(
            avgRating.toStringAsFixed(1),
            style: w600TextStyle(
              fontSize: 14,
              color: hexColor('#FFD700'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(CustomerReview review) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hexColor('#4CAF50'),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.customerName.isNotEmpty
                        ? review.customerName[0].toUpperCase()
                        : 'A',
                    style: w600TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Customer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: w600TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimeAgo(review.date),
                      style: w400TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor()
                        ? Icons.star
                        : index < review.rating
                            ? Icons.star_half
                            : Icons.star_border,
                    size: 16,
                    color: hexColor('#FFD700'),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Comment
          Expanded(
            child: Text(
              review.comment,
              style: w400TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
