import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Time and System Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '9:41',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.signal_cellular_4_bar, size: 18),
                            SizedBox(width: 8),
                            Icon(Icons.wifi, size: 18),
                            SizedBox(width: 8),
                            Icon(Icons.battery_full, size: 18),
                          ],
                        ),
                      ],
                    ),
                    // Navigation Bar
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.chevron_left, size: 24),
                              SizedBox(width: 12),
                              Text(
                                'My cart',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.more_vert, size: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Cart Items List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    CartItem(
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/274dad09f12da0d3892fc999ee19595d57f77470',
                      title: 'Pork cutlet burger and drink .',
                      description:
                          'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                      price: 2.20,
                      quantity: 3,
                      showQuantityControls: false,
                    ),
                    CartItem(
                      title: 'Mentaiko and cheese chicken ...',
                      description:
                          'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                      price: 2.20,
                      quantity: 3,
                      showQuantityControls: true,
                    ),
                    CartItem(
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/aa07a702781a4c1191b25a0f3614dd9f5cb64de5',
                      title: 'Mentaiko and cheese chicken ...',
                      description:
                          'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                      price: 2.20,
                      quantity: 3,
                      showQuantityControls: false,
                    ),
                    CartItem(
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/aa07a702781a4c1191b25a0f3614dd9f5cb64de5',
                      title: 'Mentaiko and cheese chicken ...',
                      description:
                          'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                      price: 2.20,
                      quantity: 3,
                      showQuantityControls: false,
                    ),
                    CartItem(
                      imageUrl:
                          'https://cdn.builder.io/api/v1/image/assets/TEMP/aa07a702781a4c1191b25a0f3614dd9f5cb64de5',
                      title: 'Mentaiko and cheese chicken ...',
                      description:
                          'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                      price: 2.20,
                      quantity: 3,
                      showQuantityControls: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final bool showQuantityControls;

  const CartItem({
    Key? key,
    this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.showQuantityControls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD1D1D1),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl!,
                          width: 60,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFF363853),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF14142A),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7D7575),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Over 15 mins',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7575),
                            ),
                          ),
                          _buildDivider(),
                          Text(
                            '1,8 km',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7575),
                            ),
                          ),
                          _buildDivider(),
                          Text(
                            '\$ ${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFF17228),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          if (showQuantityControls)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE7E7E7)),
                borderRadius: BorderRadius.circular(46),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF120F0F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$quantity',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '-',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF120F0F),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(46),
                color: Color(0xFFF2F1F1),
              ),
              child: Text(
                '$quantity',
                style: TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 1,
        height: 13.5,
        color: Color(0xFFF1EFE9),
      ),
    );
  }
}



// class CartScreen extends StatelessWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Custom App Bar with shadow
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               bottom: false,
//               child: Column(
//                 children: [
//                   // Status Bar
//                   SizedBox(
//                     height: 44,
//                     width: double.infinity,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 23),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '9:41',
//                             style: GoogleFonts.urbanist(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               // Signal Strength Icon
//                               CustomPaint(
//                                 size: const Size(18, 10),
//                                 painter: SignalStrengthPainter(),
//                               ),
//                               const SizedBox(width: 8),
//                               // WiFi Icon
//                               CustomPaint(
//                                 size: const Size(15, 11),
//                                 painter: WifiIconPainter(),
//                               ),
//                               const SizedBox(width: 8),
//                               // Battery Icon
//                               CustomPaint(
//                                 size: const Size(24, 12),
//                                 painter: BatteryIconPainter(),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Navigation Bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.arrow_back_ios),
//                               onPressed: () => Navigator.pop(context),
//                             ),
//                             Text(
//                               'My cart',
//                               style: GoogleFonts.fredoka(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color(0xFF120F0F),
//                               ),
//                             ),
//                           ],
//                         ),
//                         IconButton(
//                           icon: SvgPicture.string(
//                             '''<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
//                               <path fill-rule="evenodd" clip-rule="evenodd" d="M14.0003 3.20844C19.9596 3.20844 24.792 8.0396 24.792 14.0001C24.792 19.9594 19.9596 24.7918 14.0003 24.7918C8.03978 24.7918 3.20862 19.9594 3.20862 14.0001C3.20862 8.04077 8.04095 3.20844 14.0003 3.20844Z" stroke="#212121" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
//                               <path d="M18.596 14.0152H18.6065" stroke="#212121" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
//                               <path d="M13.9189 14.0152H13.9294" stroke="#212121" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
//                               <path d="M9.24166 14.0152H9.25216" stroke="#212121" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
//                             </svg>''',
//                             width: 28,
//                             height: 28,
//                           ),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Empty State Content
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 63),
//                   // Empty Cart Illustration
//                   SvgPicture.string(
//                     '''<svg width="238" height="232" viewBox="0 0 238 232" fill="none" xmlns="http://www.w3.org/2000/svg">
//                       <!-- SVG content from the design -->
//                     </svg>''',
//                     width: 237,
//                     height: 232,
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Empty',
//                     style: GoogleFonts.fredoka(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xFF212121),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'You don\'t have any foods in cart at this time',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.fredoka(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xFF3C3836),
//                       letterSpacing: 0.16,
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 21),
//                   // Order Now Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF74CA45),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(120),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 14,
//                         ),
//                       ),
//                       child: Text(
//                         'Order Now',
//                         style: GoogleFonts.fredoka(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Custom Painters for Status Bar Icons
// class SignalStrengthPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;

//     // Implementation of signal strength bars
//     final barWidth = size.width / 5;
//     for (var i = 0; i < 4; i++) {
//       final height = size.height * ((i + 1) / 4);
//       canvas.drawRect(
//         Rect.fromLTWH(i * (barWidth + 1), size.height - height, barWidth, height),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// class WifiIconPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     // Implementation of WiFi arc lines
//     for (var i = 0; i < 3; i++) {
//       final radius = size.width - (i * size.width / 3);
//       canvas.drawArc(
//         Rect.fromCircle(
//           center: Offset(size.width / 2, size.height),
//           radius: radius,
//         ),
//         3.14,
//         3.14,
//         false,
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// class BatteryIconPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;

//     // Battery outline
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(0, 0, size.width - 2, size.height),
//         const Radius.circular(2),
//       ),
//       paint,
//     );

//     // Battery level
//     paint.style = PaintingStyle.fill;
//     canvas.drawRect(
//       Rect.fromLTWH(2, 2, (size.width - 6) * 0.8, size.height - 4),
//       paint,
//     );

//     // Battery tip
//     canvas.drawRect(
//       Rect.fromLTWH(size.width - 2, size.height * 0.25, 2, size.height * 0.5),
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }