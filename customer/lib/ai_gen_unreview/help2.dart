// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// // Colors
// class AppColors {
//   static const Color primary = Color(0xFF74CA45);
//   static const Color textPrimary = Color(0xFF120F0F);
//   static const Color textSecondary = Color(0xFF847D79);
//   static const Color borderColor = Color(0xFFCEC6C5);
//   static const Color backgroundColor = Color(0xFFF9F8F6);
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color dividerColor = Color(0xFFEEEEEE);
//   static const Color inactiveText = Color(0xFF9E9E9E);
// }

// // Text Styles
// class AppTextStyles {
//   static TextStyle get title => GoogleFonts.fredoka(
//         fontSize: 22,
//         fontWeight: FontWeight.w500,
//         color: AppColors.textPrimary,
//         height: 1.2,
//       );

//   static TextStyle get tabLabel => GoogleFonts.fredoka(
//         fontSize: 18,
//         height: 1.4,
//         letterSpacing: 0.2,
//       );

//   static TextStyle get searchHint => GoogleFonts.fredoka(
//         fontSize: 16,
//         color: AppColors.textSecondary,
//       );

//   static TextStyle get chipText => GoogleFonts.fredoka(
//         fontSize: 16,
//       );

//   static TextStyle get faqTitle => GoogleFonts.fredoka(
//         fontSize: 16,
//         height: 1.2,
//         color: AppColors.textPrimary,
//       );

//   static TextStyle get faqContent => GoogleFonts.fredoka(
//         fontSize: 14,
//         height: 1.4,
//         letterSpacing: 0.2,
//         color: AppColors.textSecondary,
//       );
// }

// // Category Chip Widget
// class CategoryChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const CategoryChip({
//     Key? key,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primary : AppColors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: !isSelected ? Border.all(color: AppColors.borderColor) : null,
//         ),
//         child: Text(
//           label,
//           style: AppTextStyles.chipText.copyWith(
//             color: isSelected ? AppColors.white : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // FAQ Item Widget
// class FaqItem extends StatelessWidget {
//   final String question;
//   final String? answer;
//   final bool isExpanded;
//   final VoidCallback onTap;

//   const FaqItem({
//     Key? key,
//     required this.question,
//     this.answer,
//     required this.isExpanded,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isExpanded ? AppColors.white : AppColors.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: isExpanded
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 4),
//                 )
//               ]
//             : null,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: onTap,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     question,
//                     style: AppTextStyles.faqTitle,
//                   ),
//                 ),
//                 Transform.rotate(
//                   angle: isExpanded ? 3.14159 : 0,
//                   child: Icon(
//                     Icons.keyboard_arrow_down,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isExpanded && answer != null) ...[
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 8),
//               child: Divider(
//                 height: 1,
//                 color: AppColors.dividerColor,
//               ),
//             ),
//             Text(
//               answer!,
//               style: AppTextStyles.faqContent,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // Main Screen
// class HelpCenterScreen extends StatefulWidget {
//   const HelpCenterScreen({Key? key}) : super(key: key);

//   @override
//   State<HelpCenterScreen> createState() => _HelpCenterScreenState();
// }

// class _HelpCenterScreenState extends State<HelpCenterScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedCategoryIndex = 0;
//   int _expandedFaqIndex = 0;

//   final List<String> _categories = ['General', 'Account', 'Service', 'Payment'];
//   final List<Map<String, String>> _faqs = [
//     {
//       'question': 'What is Foodu?',
//       'answer':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     },
//     {
//       'question': 'How I can make a payment?',
//       'answer': null,
//     },
//     {
//       'question': 'How do I can cancel orders?',
//       'answer': null,
//     },
//     {
//       'question': 'How do I can delete my account?',
//       'answer': null,
//     },
//     {
//       'question': 'How do I exit the app?',
//       'answer': null,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text('Help Center', style: AppTextStyles.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
//             onPressed: () {},
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: TabBar(
//             controller: _tabController,
//             labelStyle: AppTextStyles.tabLabel,
//             unselectedLabelStyle: AppTextStyles.tabLabel,
//             labelColor: AppColors.textPrimary,
//             unselectedLabelColor: AppColors.inactiveText,
//             indicatorColor: AppColors.textPrimary,
//             indicatorWeight: 4,
//             tabs: const [
//               Tab(text: 'FAQ'),
//               Tab(text: 'Contact us'),
//             ],
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildFaqTab(),
//           const Center(child: Text('Contact us content')),
//         ],
//       ),
//     );
//   }

//   Widget _buildFaqTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildSearchBar(),
//         const SizedBox(height: 24),
//         _buildCategories(),
//         const SizedBox(height: 24),
//         _buildFaqList(),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(56),
//         border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'What are you craving?.....',
//           hintStyle: AppTextStyles.searchHint,
//           border: InputBorder.none,
//           prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategories() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(
//           _categories.length,
//           (index) => Padding(
//             padding: EdgeInsets.only(
//               right: index != _categories.length - 1 ? 12 : 0,
//             ),
//             child: CategoryChip(
//               label: _categories[index],
//               isSelected: _selectedCategoryIndex == index,
//               onTap: () => setState(() => _selectedCategoryIndex = index),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFaqList() {
//     return Column(
//       children: List.generate(
//         _faqs.length,
//         (index) => Padding(
//           padding: EdgeInsets.only(bottom: index != _faqs.length - 1 ? 12 : 0),
//           child: FaqItem(
//             question: _faqs[index]['question']!,
//             answer: _faqs[index]['answer'],
//             isExpanded: _expandedFaqIndex == index,
//             onTap: () => setState(() => _expandedFaqIndex = index),
//           ),
//         ),
//       ),
//     );
//   }
// }
