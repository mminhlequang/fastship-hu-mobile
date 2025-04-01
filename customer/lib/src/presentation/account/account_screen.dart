import 'package:app/src/base/auth/auth_cubit.dart';
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
      appBar: AppBar(
        title: const Text('Tài khoản'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              authCubit.logout();
            },
            child: Text('Đăng xuất')),
      ),
    );
  }
}
