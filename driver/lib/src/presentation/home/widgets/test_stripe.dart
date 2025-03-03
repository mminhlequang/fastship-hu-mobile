import 'dart:convert';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class WidgetTestStripe extends StatefulWidget {
  const WidgetTestStripe({super.key});

  @override
  State<WidgetTestStripe> createState() => _WidgetTestStripeState();
}

class _WidgetTestStripeState extends State<WidgetTestStripe> {
  pay() async {
    try {
      // Gọi API backend để lấy clientSecret

      final response = await http.post(
        Uri.parse('https://zennail23.com/api/v1/transaction/create_payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AppPrefs.instance.getNormalToken()}',
          'accept': '*/*',
          'X-CSRF-TOKEN': ''
        },
        body: jsonEncode({
          'amount': 1000,
          'currency': 'usd',
          // Thêm thông tin khách hàng nếu cần
          'customer_info': {
            'name': 'Nguyễn Văn A',
            'email': 'nguyenvana@example.com',
            'phone': '0987654321',
            'address': 'Hà Nội, Việt Nam'
          }
        }),
      );

      final data = jsonDecode(response.body);
      print(data);
      final clientSecret = data['data']['clientSecret'];

      // Lấy thông tin khách hàng từ API response (giả sử backend trả về)
      // Nếu backend của bạn chưa hỗ trợ, bạn cần yêu cầu backend bổ sung API endpoints để hỗ trợ
      final customerId = data['data']['customerId']; // ID khách hàng từ Stripe
      final ephemeralKeySecret =
          data['data']['ephemeralKeySecret']; // Khóa tạm thời

      // Hiển thị giao diện thanh toán
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'FastshipHu', // Tên app của Minh
          customerId: "customerId5", // ID khách hàng từ Stripe
          customerEphemeralKeySecret:
              ephemeralKeySecret, // Khóa tạm thời để xác thực
          // Cấu hình bổ sung cho khách hàng
          billingDetails: const BillingDetails(
            name: 'Nguyễn Văn A',
            email: 'nguyenvana@example.com',
            phone: '0987654321',
            address: const Address(
              city: 'Hà Nội',
              country: 'VN',
              line1: 'Địa chỉ nhà, phố',
              line2: 'Quận/Huyện',
              postalCode: '100000',
              state: 'Hà Nội',
            ),
          ),
          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'US', // Thay bằng mã quốc gia hợp lệ
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'US', // Thay bằng mã quốc gia hợp lệ
            testEnv: true, // Bỏ `testEnv: true` khi lên production
          ),
        ),
      );

      // Mở Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      print("Thanh toán thành công!");
    } catch (e) {
      print("Lỗi thanh toán: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            authCubit.logout();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
