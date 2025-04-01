import 'package:network_resources/store/models/models.dart';
import 'package:flutter/material.dart';

class WidgetSheetRestaurantReviews extends StatelessWidget {
  final StoreModel store;
  const WidgetSheetRestaurantReviews({Key? key, required this.store})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildRatingSummary(),
                      _buildFilterChips(),
                      _buildReviewsList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: Color(0xFF847D79),
            ),
          ),
          Row(
            children: [
              _buildSignalIndicators(),
              const SizedBox(width: 4),
              _buildWifiIndicators(),
              const SizedBox(width: 4),
              _buildBatteryIndicator(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalIndicators() {
    return Row(
      children: List.generate(
        4,
        (index) => Container(
          width: 3,
          height: 6.0 + (index * 2.0),
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }

  Widget _buildWifiIndicators() {
    return Row(
      children: List.generate(
        3,
        (index) => Container(
          width: 3,
          height: 6,
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator() {
    return Container(
      width: 22,
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(2),
      ),
      padding: const EdgeInsets.all(1),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(color: Colors.black),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.chevron_left),
              SizedBox(width: 12),
              Text(
                'Rating & Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF120F0F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      children: [
        Column(
          children: [
            Text(
              '4.8',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212121),
              ),
            ),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: Color(0xFFF17228),
                  size: 18,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '(4.8k reviews)',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: 1,
          height: 105,
          color: Color(0xFFEEEEEE),
        ),
        Expanded(
          child: Column(
            children: List.generate(
              5,
              (index) => _buildRatingBar(
                5 - index,
                [0.9, 0.7, 0.13, 0.2, 0.06][index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int rating, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text(
              rating.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(100),
              ),
              child: FractionallySizedBox(
                widthFactor: percentage,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF74CA45),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = ['Sort by', '5', '4', '3', '2'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: index == 0 ? 20 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF8F1F0)),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            chips[index],
            style: TextStyle(
              fontSize: 16,
              color: index == 0 ? Color(0xFF3C3836) : Color(0xFF74CA45),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return Column(
      children: List.generate(
        4,
        (index) => _buildReviewItem(
          name: [
            'Charolette Hanlin',
            'Darron Kulikowski',
            'Lauralee Quintero'
          ][index % 3],
          rating: index == 0 ? 5 : 4,
          comment: [
            'Excellent food. Menu is extensive and seasonal to a particularly high standard. Definitely fine dining 😍😍',
            'This is my absolute favorite restaurant in. The food is always fantastic and no matter what I order I am always delighted with my meal! 💯💯',
            'Delicious dishes, beautiful presentation, wide wine list and wonderful dessert. I recommend to everyone! I would like to order here again and again 👌👌',
          ][index % 3],
          likes: index == 0 ? 938 : 629,
          timeAgo: index == 0 ? '6 days ago' : '2 weeks ago',
        ),
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String comment,
    required int likes,
    required String timeAgo,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFF4F4F4),
                  ),
                  SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Color(0xFFF17228),
                        size: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.more_vert,
                    color: Color(0xFF847D79),
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF3C3836),
              height: 1.4,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: Color(0xFF74CA45),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                likes.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(width: 8),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: Color(0xFF847D79),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
