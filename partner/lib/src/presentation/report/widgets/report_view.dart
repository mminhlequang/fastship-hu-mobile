import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/report/cubit/report_cubit.dart';
import 'package:internal_core/internal_core.dart'; 
import 'package:network_resources/network_resources.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Report'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Order'),
              Tab(text: 'Bị huỷ'),
              Tab(text: 'Món ăn'),
            ],
          ),
        ),
        body: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            switch (state.status) {
              case ReportStatus.loading:
                return _buildShimmerLoading();
              case ReportStatus.success:
                return _buildContent(state);
              case ReportStatus.failure:
                return Center(child: Text(state.error));
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  height: 80,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ReportState state) {
    return TabBarView(
      children: [
        _buildOrderTab(state),
        const Center(child: Text('Bị huỷ')),
        const Center(child: Text('Món ăn')),
      ],
    );
  }

  Widget _buildOrderTab(ReportState state) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                currencyFormatted(state.totalRevenue),
                style: w600TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Doanh số',
                style: w400TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đơn hàng ${order['id']}',
                                style: w500TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${order['date']} ${order['time']}',
                                style: w400TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currencyFormatted(order['amount']),
                          style: w500TextStyle(
                            fontSize: 16,
                            color: hexColor('#4CAF50'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (order['items'] != null) ...[
                      for (final item in order['items'])
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: w400TextStyle(fontSize: 14),
                              ),
                              Text(
                                item['description'],
                                style: w400TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
