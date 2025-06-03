import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/report/cubit/report_cubit.dart';
import 'package:app/src/presentation/report/widgets/report_overview_card.dart';
import 'package:app/src/presentation/report/widgets/revenue_chart_widget.dart';
import 'package:app/src/presentation/report/widgets/top_selling_items_widget.dart';
import 'package:app/src/presentation/report/widgets/customer_reviews_widget.dart';
import 'package:app/src/presentation/report/widgets/report_shimmer_loading.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Analytics Report',
            style: w600TextStyle(fontSize: 18, color: Colors.black),
          ),
          bottom: TabBar(
            labelColor: hexColor('#4CAF50'),
            unselectedLabelColor: Colors.grey,
            indicatorColor: hexColor('#4CAF50'),
            labelStyle: w600TextStyle(fontSize: 14),
            unselectedLabelStyle: w400TextStyle(fontSize: 14),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            switch (state.status) {
              case ReportStatus.loading:
                return const ReportShimmerLoading();
              case ReportStatus.success:
                return _buildContent(state);
              case ReportStatus.failure:
                return _buildErrorView(state.error);
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(ReportState state) {
    return TabBarView(
      children: [
        _buildOverviewTab(state),
        _buildCancelledOrdersTab(state),
        _buildAnalyticsTab(state),
      ],
    );
  }

  Widget _buildOverviewTab(ReportState state) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Overview cards
            if (state.overview != null)
              ReportOverviewCard(overview: state.overview!),

            // Revenue chart
            if (state.revenueChart != null)
              RevenueChartWidget(revenueChart: state.revenueChart!),

            // Top selling items
            if (state.topSellingItems.isNotEmpty)
              TopSellingItemsWidget(items: state.topSellingItems),

            // Customer reviews
            if (state.recentReviews.isNotEmpty)
              CustomerReviewsWidget(reviews: state.recentReviews),

            // Recent orders
            if (state.recentOrders.isNotEmpty)
              _buildRecentOrdersSection(state.recentOrders),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledOrdersTab(ReportState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildCancelledOrdersStats(state),
          const SizedBox(height: 16),
          if (state.cancelledOrders.isNotEmpty)
            _buildCancelledOrdersList(state.cancelledOrders)
          else
            _buildEmptyState('No cancelled orders', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(ReportState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildPerformanceMetrics(state),
          const SizedBox(height: 16),
          if (state.revenueChart != null)
            RevenueChartWidget(revenueChart: state.revenueChart!),
          if (state.topSellingItems.isNotEmpty)
            TopSellingItemsWidget(items: state.topSellingItems),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersSection(List<Map<String, dynamic>> orders) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: hexColor('#4CAF50'),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Orders',
                  style: w600TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Text(
                  '${orders.length} orders',
                  style: w500TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...orders.take(5).map((order) => _buildOrderCard(order)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final isCompleted = order['status'] == 'completed';
    final statusColor = isCompleted ? hexColor('#4CAF50') : hexColor('#FFA142');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
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
                      'Order #${order['id']}',
                      style: w600TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order['date']} ${order['time']}',
                      style: w400TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCompleted ? 'Completed' : 'Processing',
                  style: w500TextStyle(
                    fontSize: 12,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                order['customerName'],
                style: w400TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                currencyFormatted(order['amount']),
                style: w600TextStyle(
                  fontSize: 14,
                  color: hexColor('#4CAF50'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledOrdersStats(ReportState state) {
    final totalCancelled = state.cancelledOrders.length;
    final totalRevenueLost = state.cancelledOrders
        .fold<double>(0, (sum, order) => sum + (order['amount'] as double));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '$totalCancelled',
                  style: w700TextStyle(
                    fontSize: 24,
                    color: hexColor('#EE4444'),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cancelled Orders',
                  style: w400TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  currencyFormatted(totalRevenueLost),
                  style: w700TextStyle(
                    fontSize: 24,
                    color: hexColor('#EE4444'),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lost Revenue',
                  style: w400TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledOrdersList(List<Map<String, dynamic>> orders) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cancelled Orders List',
              style: w600TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...orders.map((order) => _buildCancelledOrderCard(order)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hexColor('#EE4444').withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: hexColor('#EE4444').withOpacity(0.2)),
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
                      'Order #${order['id']}',
                      style: w600TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order['date']} ${order['time']}',
                      style: w400TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormatted(order['amount']),
                style: w600TextStyle(
                  fontSize: 14,
                  color: hexColor('#EE4444'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hexColor('#EE4444').withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Reason: ${order['reason']}',
              style: w400TextStyle(
                fontSize: 12,
                color: hexColor('#EE4444'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(ReportState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Performance',
            style: w600TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Success Rate',
                  value: '94.2%',
                  icon: Icons.check_circle,
                  color: hexColor('#4CAF50'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Cancel Rate',
                  value: '5.8%',
                  icon: Icons.cancel,
                  color: hexColor('#EE4444'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Avg Processing Time',
                  value: '12 mins',
                  icon: Icons.access_time,
                  color: hexColor('#FFA142'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Avg Rating',
                  value: '4.7/5',
                  icon: Icons.star,
                  color: hexColor('#FFD700'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: w400TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: w700TextStyle(
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: w500TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'An error occurred',
            style: w600TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: w400TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
