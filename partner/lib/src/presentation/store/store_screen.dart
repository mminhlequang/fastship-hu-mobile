import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/store_cubit.dart';
import 'widgets/store_header.dart';
import 'widgets/no_store_widget.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCubit(),
      child: const StoreScreenContent(),
    );
  }
}

class StoreScreenContent extends StatefulWidget {
  const StoreScreenContent({Key? key}) : super(key: key);

  @override
  State<StoreScreenContent> createState() => _StoreScreenContentState();
}

class _StoreScreenContentState extends State<StoreScreenContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreCubit, StoreState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Merchant Onboarding'),
            actions: const [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: null,
              ),
            ],
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'My Shop'),
                  Tab(text: 'Shop Register'),
                ],
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: My Shop
                    state.hasStore
                        ? Column(
                            children: const [
                              StoreHeader(),
                              Expanded(
                                child: Center(
                                  child: Text('Nội dung cửa hàng'),
                                ),
                              ),
                            ],
                          )
                        : const NoStoreWidget(),

                    // Tab 2: Shop Register
                    const Center(
                      child: Text('Nội dung đăng ký cửa hàng'),
                    ),
                  ],
                ),
              ),
            ],
          ),
           
        );
      },
    );
  }
}
