import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/food_cubit.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  FoodCubit get foodCubit => context.read<FoodCubit>();
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu khi cần
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      bloc: foodCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Đồ ăn'),
          ),
          body: Center(
            child: Text('Màn hình Đồ ăn'),
          ),
        );
      },
    );
  }
}
