import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/account_cubit.dart';

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
    return BlocBuilder<AccountCubit, AccountState>(
      bloc: accountCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tài khoản'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Thông tin người dùng
              _buildUserInfoSection(),

              const SizedBox(height: 24),

              // Các tùy chọn tài khoản
              _buildAccountOptions(),

              const SizedBox(height: 24),

              // Nút đăng xuất
              ElevatedButton(
                onPressed: () {
                  // TODO: Xử lý đăng xuất
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '0987654321',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'example@email.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Mở màn hình chỉnh sửa thông tin
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOptions() {
    return Column(
      children: [
        _buildOptionItem(
          icon: Icons.location_on_outlined,
          title: 'Địa chỉ của tôi',
          onTap: () {
            // TODO: Mở màn hình quản lý địa chỉ
          },
        ),
        _buildOptionItem(
          icon: Icons.payment_outlined,
          title: 'Phương thức thanh toán',
          onTap: () {
            // TODO: Mở màn hình quản lý thanh toán
          },
        ),
        _buildOptionItem(
          icon: Icons.notifications_outlined,
          title: 'Thông báo',
          onTap: () {
            // TODO: Mở màn hình cài đặt thông báo
          },
        ),
        _buildOptionItem(
          icon: Icons.help_outline,
          title: 'Trợ giúp & Hỗ trợ',
          onTap: () {
            // TODO: Mở màn hình trợ giúp
          },
        ),
        _buildOptionItem(
          icon: Icons.info_outline,
          title: 'Về chúng tôi',
          onTap: () {
            // TODO: Mở màn hình thông tin ứng dụng
          },
        ),
      ],
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
