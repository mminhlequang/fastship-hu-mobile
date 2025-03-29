import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedTipIndex = 0;
  String selectedPaymentMethod = 'cash';
  String selectedShippingOption = 'super_fast';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildContent(),
                SizedBox(height: 130), // Space for bottom bar
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: 14),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back_ios, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Kentucky Fried Chicken',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF120F0F),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFFF17228),
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '2 Km',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 14,
                      color: Color(0xFFF17228),
                      letterSpacing: 0.28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _buildDeliveryAddress(),
          SizedBox(height: 16),
          _buildShippingOptions(),
          SizedBox(height: 16),
          _buildOrderItems(),
          SizedBox(height: 16),
          _buildPaymentMethods(),
          SizedBox(height: 16),
          _buildCourierTip(),
          SizedBox(height: 16),
          _buildOrderSummary(),
          SizedBox(height: 16),
          _buildPromotionSection(),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF9F8F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF74CA45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.home, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My home',
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 16,
                            color: Color(0xFF120F0F),
                          ),
                        ),
                        Text(
                          '3831 Cedar Lane, Somerville, MA 02143',
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 14,
                            color: Color(0xFF3C3836),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 24),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add detailed address and delivery instructions',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 12,
                        color: Color(0xFF847D79),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: Color(0xFF74CA45),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFF1EFE9)),
          ),
          child: Row(
            children: [
              Icon(Icons.store, color: Color(0xFF847D79)),
              SizedBox(width: 8),
              Text(
                'Pick up yourself',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  color: Color(0xFF847D79),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping options',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 16,
            color: Color(0xFF14142A),
          ),
        ),
        SizedBox(height: 12),
        Column(
          children: [
            _buildShippingOption(
              'Super fast',
              '10 mins',
              '\$ 1,00',
              'super_fast',
            ),
            SizedBox(height: 8),
            _buildShippingOption(
              'basic',
              '25 mins',
              '\$ 2,00',
              'basic',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingOption(
    String title,
    String time,
    String price,
    String value,
  ) {
    final isSelected = selectedShippingOption == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedShippingOption = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF9F8F6),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Color(0xFF74CA45))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    color: Color(0xFF847D79),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C3836),
                  ),
                ),
              ],
            ),
            Text(
              price,
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF120F0F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order items',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 16,
                color: Color(0xFF000000),
                letterSpacing: 0.16,
              ),
            ),
            Row(
              children: [
                Icon(Icons.add, color: Color(0xFF74CA45)),
                SizedBox(width: 4),
                Text(
                  'Add more',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    color: Color(0xFF74CA45),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Color(0xFFCEC6C5), style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              _buildOrderItem(3),
              SizedBox(height: 12),
              _buildOrderItem(2),
              SizedBox(height: 10),
              _buildOrderItemWithDelete(2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(int quantity) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF2F1F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/aae71f0785a920ba3471820840318b8b8b5598aa',
            width: 43,
            height: 43,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pork cutlet burger and drink set',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 14,
                  color: Color(0xFF3C3836),
                  letterSpacing: 0.14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$2,18.55',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF120F0F),
                  letterSpacing: 0.14,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.edit,
          color: Color(0xFF74CA45),
          size: 24,
        ),
      ],
    );
  }

  Widget _buildOrderItemWithDelete(int quantity) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF9F8F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildOrderItem(quantity),
          ),
        ),
        Container(
          height: 62,
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Color(0xFFFA4069),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.delete_outline, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment method',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 16,
                color: Color(0xFF14142A),
              ),
            ),
            Row(
              children: [
                Icon(Icons.add, color: Color(0xFF74CA45)),
                SizedBox(width: 4),
                Text(
                  'Add more',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    color: Color(0xFF74CA45),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF9F8F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildPaymentOption('Cash', 'cash'),
              Divider(color: Color(0xFFF1EFE9)),
              _buildPaymentOption('Bank Transfer', 'bank_transfer'),
              Divider(color: Color(0xFFF1EFE9)),
              _buildPaymentOption('Sepa', 'sepa'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                  value: value,
                  groupValue: selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPaymentMethod = newValue;
                      });
                    }
                  },
                  activeColor: Color(0xFF333333),
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 14,
                    color: Color(0xFF333333),
                    letterSpacing: 0.28,
                  ),
                ),
              ],
            ),
            if (value == 'bank_transfer')
              Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/9b4832767fc112ee3b2e515731780ce1de1d92d0',
                  width: 49,
                  height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCourierTip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add courier tip',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 16,
                color: Color(0xFF14142A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '100% of the tip goes to your courier',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 14,
                color: Color(0xFF847D79),
                letterSpacing: 0.14,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildTipOption('\$0', 0),
            SizedBox(width: 11),
            _buildTipOption('\$5', 1),
            SizedBox(width: 11),
            _buildTipOption('\$10', 2),
            SizedBox(width: 11),
            _buildTipOption('\$15', 3),
            SizedBox(width: 11),
            _buildCustomTipOption(),
          ],
        ),
      ],
    );
  }

  Widget _buildTipOption(String amount, int index) {
    final isSelected = selectedTipIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTipIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color(0xFF74CA45) : Color(0xFFCEC6C5),
            ),
          ),
          child: Text(
            '+ $amount',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16,
              color: isSelected ? Color(0xFF538D33) : Color(0xFF847D79),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTipOption() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFCEC6C5)),
        ),
        child: Icon(Icons.edit, color: Color(0xFF847D79)),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFCEC6C5), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$ 12,00'),
          SizedBox(height: 12),
          _buildSummaryRow('Application fee', '\$ 2,00'),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_offer, color: Color(0xFFF17228)),
                  SizedBox(width: 8),
                  Text(
                    '\$0.50 off, more deals below',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 16,
                      color: Color(0xFF3C3836),
                      letterSpacing: 0.16,
                    ),
                  ),
                ],
              ),
              Text(
                '- \$ 0,50',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF17228),
                  letterSpacing: 0.16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            color: Color(0xFF3C3836),
            letterSpacing: 0.16,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091230),
            letterSpacing: 0.16,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9F8F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: Color(0xFFF17228)),
              SizedBox(width: 12),
              Text(
                'Use a discount or promotion',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  color: Color(0xFFF17228),
                  letterSpacing: 0.16,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 34),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(17, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 18,
                    color: Colors.black,
                    letterSpacing: 0.18,
                  ),
                ),
                Text(
                  '\$ 12,00',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 0.18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Check out',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(120),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
