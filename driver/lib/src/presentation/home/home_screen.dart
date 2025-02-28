import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String bearerToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJFQ09TIiwiYXVkIjoiZWNvc0BnbWFpbC5jb20iLCJpYXQiOjE3NDA3MDk2MjQsIm5iZiI6MTc0MDcwOTYyNSwiZXhwIjoxNzQwNzEzMjI0LCJkYXRhIjp7ImlkIjo1LCJuYW1lIjoiXHUwMTEwXHUwMGVjbmggRFx1MDFiMFx1MDFhMW5nIiwicGhvbmUiOiIwOTY0NTQxMzQwIiwicGFzc3dvcmQiOiJlMTBhZGMzOTQ5YmE1OWFiYmU1NmUwNTdmMjBmODgzZSJ9fQ.yhcq4zN8yFsjry1z7GPsgl4FpT4hS7O_heLAhDgEtOk";
  pay() async {
    try {
      // Gọi API backend để lấy clientSecret

      final response = await http.post(
        Uri.parse('https://zennail23.com/api/v1/transaction/create_payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
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
        child: Text('Home Screen'),
      ),
    );
  }
}
//import 'dart:async';

// import 'package:app/src/presentation/widgets/widget_app_map.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_map_animations/flutter_map_animations.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:gap/gap.dart';
// import 'package:internal_core/internal_core.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:app/src/utils/utils.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Completer<AnimatedMapController> mapController =
//       Completer<AnimatedMapController>();
//   final _searchController = TextEditingController();
//   Timer? _debounce;
//   List<Map<String, dynamic>> _searchResults = [];
//   bool _isLoading = false;
//   bool _showResults = false;
//   Map<String, dynamic>? _selectedPlace;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   // Hàm tìm kiếm với debounce
//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (query.isNotEmpty) {
//         _searchPlaces(query);
//       } else {
//         setState(() {
//           _searchResults = [];
//           _showResults = false;
//         });
//       }
//     });
//   }

//   // Gọi API HERE để tìm kiếm địa điểm
//   Future<void> _searchPlaces(String query) async {
//     setState(() {
//       _isLoading = true;
//       _showResults = true;
//     });

//     try {
//       // Thay YOUR_API_KEY bằng API key thực tế của bạn
//       final apiKey = '18Qu8ZjLof_XOVK_n3T7659DntYP9AO6p4ohbU7gKjE';
//       final url =
//           'https://geocode.search.hereapi.com/v1/geocode?lang=en&q=$query&apiKey=$apiKey';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = json.decode(utf8.decode(response.bodyBytes));
//         print(data);

//         setState(() {
//           _searchResults = List<Map<String, dynamic>>.from(data['items']);
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _searchResults = [];
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _searchResults = [];
//         _isLoading = false;
//       });
//     }
//   }

//   // Di chuyển bản đồ đến vị trí được chọn
//   void _moveToLocation(
//       double lat, double lng, Map<String, dynamic> place) async {
//     final controller = await mapController.future;
//     controller.animateTo(
//       dest: LatLng(lat, lng),
//       zoom: 15,
//     );

//     setState(() {
//       _showResults = false;
//       _selectedPlace = place;
//       _searchController.text = place['title'] ?? '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appColorBackground,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Tiêu đề trang
//                   Text(
//                     'Tìm kiếm địa điểm'.tr(),
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const Gap(16),
//                   TextField(
//                     controller: _searchController,
//                     onChanged: _onSearchChanged,
//                     decoration: InputDecoration(
//                       hintText: 'Tìm kiếm địa điểm'.tr(),
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                   if (_showResults)
//                     Container(
//                       constraints: const BoxConstraints(maxHeight: 300),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: _isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : _searchResults.isEmpty
//                               ? ListTile(
//                                   title: Text('Không tìm thấy kết quả'.tr()))
//                               : ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: _searchResults.length,
//                                   itemBuilder: (context, index) {
//                                     final place = _searchResults[index];
//                                     return ListTile(
//                                       title: Text(place['title'] ?? ''),
//                                       subtitle:
//                                           Text(place['address']['label'] ?? ''),
//                                       onTap: () {
//                                         final position = place['position'];
//                                         if (position != null) {
//                                           _moveToLocation(
//                                             position['lat'],
//                                             position['lng'],
//                                             place,
//                                           );
//                                         }
//                                       },
//                                     );
//                                   },
//                                 ),
//                     ),
//                   // Hiển thị thông tin địa điểm đã chọn
//                   if (_selectedPlace != null && !_showResults)
//                     Container(
//                       margin: const EdgeInsets.only(top: 12),
//                       padding: const EdgeInsets.all(12),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on,
//                                   color: Colors.redAccent),
//                               const Gap(8),
//                               Expanded(
//                                 child: Text(
//                                   _selectedPlace!['title'] ?? '',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Gap(4),
//                           Text(
//                             _selectedPlace!['address']['label'] ?? '',
//                             style: TextStyle(
//                               color: Colors.grey.shade700,
//                               fontSize: 14,
//                             ),
//                           ),
//                           if (_selectedPlace!['position'] != null)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 4),
//                               child: Text(
//                                 'Vị trí: ${_selectedPlace!['position']['lat']}, ${_selectedPlace!['position']['lng']}',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade600,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: WidgetAppFlutterMapAnimation(
//                 mapController: mapController,
//                 initialCenter: LatLng(37.7749, -122.4194),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
