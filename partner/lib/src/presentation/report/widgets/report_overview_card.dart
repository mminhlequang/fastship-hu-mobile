import 'package:flutter/material.dart';
import 'package:app/src/presentation/report/cubit/report_cubit.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/reports/models/models.dart';

class ReportOverviewCard extends StatefulWidget {
  final ReportOverviewModel overview;

  const ReportOverviewCard({
    super.key,
    required this.overview,
  });

  @override
  State<ReportOverviewCard> createState() => _ReportOverviewCardState();
}

class _ReportOverviewCardState extends State<ReportOverviewCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                hexColor('#4CAF50'),
                hexColor('#45A049'),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: hexColor('#4CAF50').withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Today\'s Overview',
                      style: w600TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricItem(
                        title: 'Revenue',
                        value: currencyFormatted(widget.overview.todayRevenue),
                        subtitle: _buildGrowthIndicator(),
                        icon: Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricItem(
                        title: 'Orders',
                        value: '${widget.overview.todayOrders}',
                        subtitle: Text(
                          'Yesterday: ${widget.overview.yesterdayOrders}',
                          style: w400TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        icon: Icons.shopping_cart,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricItem(
                        title: 'Customers',
                        value: '${widget.overview.totalCustomers}',
                        subtitle: Text(
                          'Total',
                          style: w400TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricItem(
                        title: 'Avg Order Value',
                        value: currencyFormatted(widget.overview.avgOrderValue),
                        subtitle: Text(
                          'Per Order',
                          style: w400TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        icon: Icons.analytics,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required Widget subtitle,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: w400TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: w700TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        subtitle,
      ],
    );
  }

  Widget _buildGrowthIndicator() {
    final isPositive = (widget.overview.growthRate ?? 0) > 0;
    return Row(
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: Colors.white70,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${widget.overview.growthRate?.toStringAsFixed(1)}%',
          style: w600TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
