import 'package:app/src/network_resources/store/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetSheetRestaurantInfo extends StatelessWidget {
  final StoreModel store;
  const WidgetSheetRestaurantInfo({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRestaurantInfo(),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  _buildRatingsSection(),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  _buildOverviewSection(),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  _buildAddressSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 157,
          width: double.infinity,
          child: Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/b4b64fc16c810bab9d9d147a8f07e5e6b973de2c',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 157,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: SvgPicture.string(
                  '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M16 5L8.43004 11.6237C8.20238 11.8229 8.20238 12.1771 8.43004 12.3763L16 19"
                    stroke="white" stroke-width="1.5" stroke-linecap="round"/>
                  </svg>''',
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: SvgPicture.string(
                  '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M3.98389 11.6106L9.11798 18.5107C10.5955 20.4964 13.4045 20.4964 14.882 18.5107L20.0161 11.6106C21.328 9.84746 21.328 7.34218 20.0161 5.57906C18.0957 2.9981 13.6571 3.76465 12 6.54855C10.3429 3.76465 5.90428 2.9981 3.9839 5.57906C2.67204 7.34218 2.67203 9.84746 3.98389 11.6106Z"
                    fill="white"/>
                  </svg>''',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Japanese',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF847D79),
              ),
            ),
            _buildDivider(),
            Text(
              'Bowl',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF847D79),
              ),
            ),
            _buildDivider(),
            Text(
              'Chicken',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF847D79),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          'Kentucky Fried Chicken',
          style: TextStyle(
            fontSize: 29,
            color: Color(0xFF120F0F),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Opening Hours( Monday - Sunday) :',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF847D79),
              ),
            ),
            Text(
              '09:00am. - 21:15pm',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF120F0F),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rating & Reviews',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF212121),
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Column(
              children: [
                Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 36,
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
                Text(
                  '(4.8k reviews)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 105,
              color: Color(0xFFEEEEEE),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  _buildRatingBar(5, 0.90),
                  _buildRatingBar(4, 0.70),
                  _buildRatingBar(3, 0.13),
                  _buildRatingBar(2, 0.20),
                  _buildRatingBar(1, 0.06),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF120F0F),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF847D79),
                ),
              ),
              TextSpan(
                text: ' Read more...',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF17228),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildTimeRow('Monday - Friday', '10:00 - 22.00'),
        _buildTimeRow('Saturyday - Sunday', '12:00 - 20.00'),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SvgPicture.string(
              '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M8.53162 2.93677C10.7165 1.66727 13.402 1.68946 15.5664 2.99489C17.7095 4.32691 19.012 6.70418 18.9998 9.26144C18.95 11.8019 17.5533 14.19 15.8075 16.0361C14.7998 17.1064 13.6726 18.0528 12.4488 18.856C12.3228 18.9289 12.1848 18.9777 12.0415 19C11.9036 18.9941 11.7693 18.9534 11.6508 18.8814C9.78243 17.6746 8.14334 16.134 6.81233 14.334C5.69859 12.8314 5.06584 11.016 5 9.13442C4.99856 6.57225 6.34677 4.20627 8.53162 2.93677ZM9.79416 10.1948C10.1617 11.1008 11.0292 11.6918 11.9916 11.6918C12.6221 11.6964 13.2282 11.4438 13.6748 10.9905C14.1214 10.5371 14.3715 9.92064 14.3692 9.27838C14.3726 8.29804 13.7955 7.41231 12.9073 7.03477C12.0191 6.65723 10.995 6.86235 10.3133 7.55435C9.63159 8.24635 9.42664 9.28872 9.79416 10.1948Z"
                fill="#F17228"/>
              </svg>''',
            ),
            const SizedBox(width: 8),
            Text(
              '179 Sampson Street, Georgetown, CO 80444',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF3C3836),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF1EFE9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF74CA45).withOpacity(0.2),
                      ),
                      child: Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF74CA45).withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 66,
                      left: 170,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: 158,
                        child: Text(
                          '179 Sampson Street, Georgetown, CO 80444',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF120F0F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ..._buildMapAddresses(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int rating, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 10,
          child: Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF212121),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: FractionallySizedBox(
              widthFactor: percentage,
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
    );
  }

  Widget _buildTimeRow(String days, String hours) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            days,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF120F0F),
            ),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF847D79),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hours,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFF17228),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Container(
        width: 1,
        height: 13,
        color: Color(0xFFCEC6C5),
      ),
    );
  }

  List<Widget> _buildMapAddresses() {
    return [
      Positioned(
        left: 47,
        top: 151,
        child: Transform.rotate(
          angle: 13.67 * 3.14159 / 180,
          child: Text(
            '9 Evergreen Center',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF847D79),
            ),
          ),
        ),
      ),
      Positioned(
        left: 218,
        top: 19,
        child: Transform.rotate(
          angle: -31.639 * 3.14159 / 180,
          child: Text(
            '657 Lukken Court',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF847D79),
            ),
          ),
        ),
      ),
      Positioned(
        left: 310,
        top: 116,
        child: Transform.rotate(
          angle: -66.128 * 3.14159 / 180,
          child: Text(
            '59797 Elka Trail',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF847D79),
            ),
          ),
        ),
      ),
      Positioned(
        left: 37,
        top: 36,
        child: Transform.rotate(
          angle: -3.812 * 3.14159 / 180,
          child: Text(
            '488 Farwell Road',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF847D79),
            ),
          ),
        ),
      ),
    ];
  }
}
