import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_resources/driver_statistics/models/models.dart';
import 'package:network_resources/network_resources.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/statistics/widgets/income_pie_chart.dart';
import 'package:app/src/presentation/statistics/cubit/statistics_cubit.dart';

enum StatisticsPeriod {
  today('Today'),
  yesterday('Yesterday'),
  thisWeek('This Week'),
  lastWeek('Last Week'),
  thisMonth('This Month'),
  lastMonth('Last Month'),
  thisYear('This Year'),
  custom('Custom');

  const StatisticsPeriod(this.label);
  final String label;
}

enum StatisticsType {
  income('Income'),
  trips('Trips'),
  distance('Distribution'),
  time('Time');

  const StatisticsType(this.label);
  final String label;
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit()..getStatistics(),
      child: const StatisticsView(),
    );
  }
}

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView>
    with TickerProviderStateMixin {
  StatisticsPeriod selectedPeriod = StatisticsPeriod.thisWeek;
  StatisticsType selectedType = StatisticsType.income;

  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final params = _getParamsForPeriod(selectedPeriod);
    context.read<StatisticsCubit>().getStatistics(params: params);
  }

  Map<String, dynamic> _getParamsForPeriod(StatisticsPeriod period) {
    // This is a simplified version. You might need a more robust implementation
    // to handle date ranges for 'custom' period.
    final now = DateTime.now();
    switch (period) {
      case StatisticsPeriod.today:
        return {'from': now.toIso8601String(), 'to': now.toIso8601String()};
      case StatisticsPeriod.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        return {
          'from': yesterday.toIso8601String(),
          'to': yesterday.toIso8601String()
        };
      case StatisticsPeriod.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return {
          'from': startOfWeek.toIso8601String(),
          'to': now.toIso8601String()
        };
      // Add other cases as needed
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Statistics'.tr()),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: BlocConsumer<StatisticsCubit, StatisticsState>(
        listener: (context, state) {
          if (state.status == StatisticsStatus.success) {
            _animationController.forward(from: 0.0);
          } else if (state.status == StatisticsStatus.failure) {
            // appShowSnackBar(
            //   msg: state.errorMessage ?? 'Failed to load data',
            //   context: context,
            //   type: AppSnackBarType.error,
            // );
          }
        },
        builder: (context, state) {
          if (state.status == StatisticsStatus.loading &&
              state.overview == null) {
            return _buildShimmerLoading();
          }
          return _buildContent(state);
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Period selector shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Gap(20),

            // Net income card shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const Gap(20),

            // Chart shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const Gap(20),

            // Stats cards shimmer
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < 2 ? 8.0 : 0,
                      left: index > 0 ? 8.0 : 0,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(StatisticsState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const Gap(20),
            _buildNetIncomeCard(state),
            const Gap(20),
            _buildTabSection(),
            const Gap(20),
            _buildTabContent(state),
            const Gap(20),
            _buildStatsCards(state),
            const Gap(20),
            _buildDetailsList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButton<StatisticsPeriod>(
          value: selectedPeriod,
          isExpanded: true,
          underline: const SizedBox(),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: StatisticsPeriod.values
              .map((period) => DropdownMenuItem<StatisticsPeriod>(
                    value: period,
                    child: Text(period.label),
                  ))
              .toList(),
          onChanged: (StatisticsPeriod? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPeriod = newValue;
              });
              _loadData();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNetIncomeCard(StatisticsState state) {
    final overview = state.overview;
    final netIncome = overview?.netIncome?.amount ?? 0.0;
    final grossIncome = overview?.grossIncome?.amount ?? 0.0;
    final appFee = grossIncome - netIncome;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Income'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(10),
            Text(
              currencyFormatted(netIncome),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeInfo('Gross'.tr(), currencyFormatted(grossIncome)),
                _buildIncomeInfo('App Fee'.tr(), currencyFormatted(appFee)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.green[600],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.green[600],
        indicatorWeight: 3,
        tabs:
            StatisticsType.values.map((type) => Tab(text: type.label)).toList(),
      ),
    );
  }

  Widget _buildTabContent(StatisticsState state) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(_animationController),
            child: SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChart(state.incomeChart?.chartData),
                  _buildChart(state.tripsChart?.chartData),
                  _buildPieChart(state.incomeBreakdown),
                  _buildChart(state.timeChart?.chartData),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(List<dynamic>? chartData) {
    if (chartData == null || chartData.isEmpty) {
      return Center(child: Text('No data available'.tr()));
    }

    final spots = chartData.asMap().entries.map((entry) {
      // Assuming each item in chartData has a 'value' property.
      // The value can be int or double, so we handle it as num.
      final num value = entry.value.value ?? 0;
      return FlSpot(entry.key.toDouble(), value.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  String timeFormatted(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Widget _buildPieChart(DriverStatIncomeBreakdown? breakdownData) {
    if (breakdownData == null ||
        breakdownData.breakdown == null ||
        breakdownData.breakdown!.isEmpty) {
      return Center(child: Text('No data available'.tr()));
    }

    // Extract values from the breakdown list. This is an assumption based on
    // the linter errors. You might need to adjust the 'type' strings.
    final breakdownMap = {
      for (var item in breakdownData.breakdown!)
        item.type ?? '': item.amount ?? 0.0
    };

    return IncomePieChart(
      grossIncome: breakdownData.grossIncome ?? 0.0,
      netIncome: breakdownMap['net_income'] ??
          (breakdownData.grossIncome ?? 0.0) -
              (breakdownData.totalDeductions ?? 0.0),
      platformFee: breakdownMap['platform_fee'] ?? 0.0,
      fuelCost: breakdownMap['fuel_cost'] ?? 0.0,
      insurance: breakdownMap['insurance_cost'] ?? 0.0,
    );
  }

  Widget _buildStatsCards(StatisticsState state) {
    final stats = state.overview?.stats;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Completed Trips'.tr(),
            stats?.totalTrips?.count?.toString() ?? '...',
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
        const Gap(16),
        Expanded(
          child: _buildStatCard(
            'Time Online'.tr(),
            stats?.onlineHours?.totalMinutes != null
                ? timeFormatted(
                    Duration(minutes: stats!.onlineHours!.totalMinutes!))
                : '...',
            Icons.timer,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsList(StatisticsState state) {
    final details = state.details?.incomeDetails;
    if (details == null || details.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('No details available for this period.'.tr(),
              style: TextStyle(color: Colors.grey.shade600)),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details'.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Gap(10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: details.length,
          itemBuilder: (context, index) {
            final item = details[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(item.label ?? 'N/A'),
                subtitle:
                    item.description != null ? Text(item.description!) : null,
                trailing: Text(
                  currencyFormatted(item.amount ?? 0),
                  style: TextStyle(
                    color:
                        (item.isPositive ?? false) ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIncomeInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: color),
            const Gap(12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const Gap(20),
              Text(
                'Period',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const Gap(10),
              Wrap(
                spacing: 8,
                children: StatisticsPeriod.values.map((period) {
                  final isSelected = selectedPeriod == period;
                  return FilterChip(
                    label: Text(period.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedPeriod = period;
                      });
                      Navigator.pop(context);
                      _loadData();
                    },
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green[600],
                  );
                }).toList(),
              ),
              const Gap(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
