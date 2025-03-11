import 'package:flutter/material.dart';
import '../cubit/reviews_cubit.dart';

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          if (review.foodImage != null) _buildFoodImage(),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14),
          ),
          if (review.merchantReply != null) _buildMerchantReply(),
          const SizedBox(height: 12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(review.userAvatar),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                review.userPhone,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              review.date,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFoodImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          review.foodImage!,
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMerchantReply() {
    final reply = review.merchantReply!;
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reply.merchantName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                reply.date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reply.comment,
            style: const TextStyle(fontSize: 14),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: const Text(
              'Xem thêm',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.reply, size: 16, color: Colors.grey),
          label: const Text(
            'Phản hồi',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.visibility, size: 16, color: Colors.grey),
          label: const Text(
            'Xem đơn hàng',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
