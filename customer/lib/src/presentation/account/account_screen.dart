import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu khi cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: EdgeInsets.symmetric(horizontal: 16.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildOrangeBanner(),
              _buildProfileSection(),
              _buildPointsAndVouchersSection(),
              _buildMenuSection(),
              _buildSupportSection(),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 11, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Urbanist',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Profile Settings',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 22,
              color: const Color(0xFF120F0F),
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/02f7ebb29b0d1a1a4f19a44cc7e0dc293b2be4f9?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
              width: double.infinity,
              fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _buildOrangeBanner() {
    return Container(
      height: 139,
      decoration: BoxDecoration(
        color: const Color(0xFFF17228),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      // margin: const EdgeInsets.only(top:  118),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/cd4af61ec1e39056015f3d9a2ad523c06ff0480d?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
              width: 64,
              height: 64,
              fit: BoxFit.contain),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Frances Swann',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Fredoka',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Silver',
                                style: TextStyle(
                                  color: const Color(0xFF878787),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Image.network(
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/8228b2d08d101e44d7d90fcdb742214cb41e82de?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Albertstevano@gmail.com',
                      style: TextStyle(
                        color: const Color(0xFFF1EFE9),
                        fontFamily: 'Fredoka',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 24, height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsAndVouchersSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem('Point', '10000 Point',
              'https://cdn.builder.io/api/v1/image/assets/TEMP/84039867190610438682158d072199e48e4ad534?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
          _buildInfoItem('Voucher', '400+ voucher',
              'https://cdn.builder.io/api/v1/image/assets/TEMP/41197bfbf2e94ee4832b859ad33d972aff3f3158?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, String imageUrl) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Image.network(
              imageUrl,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF120F0F),
                fontFamily: 'Fredoka',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFFF17228),
                fontFamily: 'Fredoka',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1EFE9)),
      ),
      child: Column(
        children: [
          _buildMenuItem('Personal Data', 'URL_profile'),
          _buildMenuItem('My Favorite',
              'https://cdn.builder.io/api/v1/image/assets/TEMP/d26cbd321bbc8a48ace9503f5c2105a346ed5522?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
          _buildMenuItem('Extra Card',
              'https://cdn.builder.io/api/v1/image/assets/TEMP/395e6fbd712c94bc29c9ac08a07ff4d118871b48?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
          _buildMenuItem('Settings', 'URL_settings'),
          _buildMenuItem('Security', 'URL_shield'),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Text(
            'Support',
            style: TextStyle(
              color: const Color(0xFF878787),
              fontFamily: 'Fredoka',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 7),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1EFE9)),
          ),
          child: Column(
            children: [
              _buildMenuItem('Help Center',
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/5e0a2751b550a8b4f5d31439eea07e0030c576cc?placeholderIfAbsent=true&apiKey=4f64436fe9d5484a9dcabcc2b9ed4215'),
              _buildMenuItem('Request Account Deletion', 'URL_profile'),
              _buildMenuItem('Add another account', 'URL_profile'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Image.network(
                imageUrl,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xFF3C3836),
                fontFamily: 'Fredoka',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFF3C3836),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(120),
            side: BorderSide(color: const Color(0xFFF17228)),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFFF17228),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'Log out',
              style: TextStyle(
                color: const Color(0xFFF17228),
                fontFamily: 'Fredoka',
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
