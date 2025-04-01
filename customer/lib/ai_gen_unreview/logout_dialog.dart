// import 'package:flutter/material.dart';
// import '../theme/colors.dart';

// class LogoutDialog extends StatelessWidget {
//   final VoidCallback? onCancel;
//   final VoidCallback? onConfirm;

//   const LogoutDialog({
//     Key? key,
//     this.onCancel,
//     this.onConfirm,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         color: AppColors.backgroundColor,
//         child: Center(
//           child: Container(
//             width: 361,
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 50,
//                   offset: const Offset(0, 0),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Column(
//                   children: [
//                     Text(
//                       'Logout',
//                       style: TextStyle(
//                         color: AppColors.textPrimary,
//                         fontFamily: 'Fredoka',
//                         fontSize: 32,
//                         fontWeight: FontWeight.w500,
//                         height: 1.2,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Are you sure you want to log out?',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: AppColors.textSecondary,
//                         fontFamily: 'Fredoka',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         height: 1.4,
//                         letterSpacing: 0.18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: onCancel,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 14,
//                             horizontal: 19,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.buttonPrimary,
//                             borderRadius: BorderRadius.circular(120),
//                           ),
//                           child: const Text(
//                             'Cancel',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: 'Fredoka',
//                               fontSize: 18,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: onConfirm,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 14,
//                             horizontal: 19,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.white,
//                             borderRadius: BorderRadius.circular(120),
//                             border: Border.all(
//                               color: AppColors.buttonSecondaryBorder,
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             'yes, Sure',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: AppColors.buttonSecondaryText,
//                               fontFamily: 'Fredoka',
//                               fontSize: 18,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
