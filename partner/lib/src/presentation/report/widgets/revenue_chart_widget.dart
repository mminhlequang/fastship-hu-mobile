import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app/src/presentation/report/cubit/report_cubit.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';

class RevenueChartWidget extends StatefulWidget {
  final RevenueChart revenueChart;

  const RevenueChartWidget({
    super.key,
    required this.revenueChart,
  });

  @override
  State<RevenueChartWidget> createState() => _RevenueChartWidgetState();
}

class _RevenueChartWidgetState extends State<RevenueChartWidget>
    with TickerProviderStateMixin {
  int selectedTabIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> tabs = ['Daily', 'Weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue Chart',
                  style: w600TextStyle(fontSize: 18),
                ),
                Icon(
                  Icons.show_chart,
                  color: hexColor('#4CAF50'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTabSelector(),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Opacity(
                    opacity: _animation.value,
                    child: SizedBox(
                      height: 200,
                      child: _buildChart(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;
          final isSelected = selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTabIndex = index;
                });
                _animationController.reset();
                _animationController.forward();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? hexColor('#4CAF50') : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: w500TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart() {
    final data = _getCurrentData();
    if (data.isEmpty) return const SizedBox();

    final maxY = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minY = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    return LineChart(
      LineChartData(
        maxY: maxY * 1.1,
        minY: minY * 0.9,
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.value);
            }).toList(),
            isCurved: true,
            curveSmoothness: 0.35,
            preventCurveOverShooting: true,
            gradient: LinearGradient(
              colors: [
                hexColor('#4CAF50'),
                hexColor('#45A049'),
              ],
            ),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: hexColor('#4CAF50'),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  hexColor('#4CAF50').withOpacity(0.3),
                  hexColor('#4CAF50').withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index].period,
                      style: w400TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatCurrency(value),
                  style: w400TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                hexColor('#4CAF50').withOpacity(0.9),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= 0 && index < data.length) {
                  return LineTooltipItem(
                    '${data[index].period}\n${currencyFormatted(spot.y)}',
                    w500TextStyle(fontSize: 12, color: Colors.white),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final data = _getCurrentData();
    if (data.isEmpty) return const SizedBox();

    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    final average = total / data.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(
          title: 'Total',
          value: currencyFormatted(total),
          color: hexColor('#4CAF50'),
        ),
        _buildLegendItem(
          title: 'Average',
          value: currencyFormatted(average),
          color: hexColor('#FFA142'),
        ),
        _buildLegendItem(
          title: 'Highest',
          value: currencyFormatted(
              data.map((e) => e.value).reduce((a, b) => a > b ? a : b)),
          color: hexColor('#0085FF'),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: w400TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: w600TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  List<ChartData> _getCurrentData() {
    switch (selectedTabIndex) {
      case 0:
        return widget.revenueChart.dailyRevenue;
      case 1:
        return widget.revenueChart.weeklyRevenue;
      case 2:
        return widget.revenueChart.monthlyRevenue;
      default:
        return widget.revenueChart.dailyRevenue;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
