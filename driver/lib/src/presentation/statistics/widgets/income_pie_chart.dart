import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';

class IncomePieChart extends StatefulWidget {
  final double grossIncome;
  final double platformFee;
  final double fuelCost;
  final double insurance;
  final double netIncome;

  const IncomePieChart({
    super.key,
    required this.grossIncome,
    required this.platformFee,
    required this.fuelCost,
    required this.insurance,
    required this.netIncome,
  });

  @override
  State<IncomePieChart> createState() => _IncomePieChartState();
}

class _IncomePieChartState extends State<IncomePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
              'Income Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _getSections(),
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildLegendItem(
                        'Net Income',
                        widget.netIncome,
                        Colors.green[600]!,
                        0,
                      ),
                      _buildLegendItem(
                        'Platform Fee',
                        widget.platformFee,
                        Colors.red[400]!,
                        1,
                      ),
                      _buildLegendItem(
                        'Fuel & Maintenance',
                        widget.fuelCost,
                        Colors.orange[400]!,
                        2,
                      ),
                      _buildLegendItem(
                        'Insurance',
                        widget.insurance,
                        Colors.blue[400]!,
                        3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final total = widget.grossIncome;

    return [
      // Net Income
      PieChartSectionData(
        color: Colors.green[600],
        value: widget.netIncome,
        title: '${((widget.netIncome / total) * 100).toStringAsFixed(1)}%',
        radius: touchedIndex == 0 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // Platform Fee
      PieChartSectionData(
        color: Colors.red[400],
        value: widget.platformFee,
        title: '${((widget.platformFee / total) * 100).toStringAsFixed(1)}%',
        radius: touchedIndex == 1 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // Fuel & Maintenance
      PieChartSectionData(
        color: Colors.orange[400],
        value: widget.fuelCost,
        title: '${((widget.fuelCost / total) * 100).toStringAsFixed(1)}%',
        radius: touchedIndex == 2 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 2 ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // Insurance
      PieChartSectionData(
        color: Colors.blue[400],
        value: widget.insurance,
        title: '${((widget.insurance / total) * 100).toStringAsFixed(1)}%',
        radius: touchedIndex == 3 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 3 ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem(String label, double value, Color color, int index) {
    final isSelected = touchedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.grey[800]!, width: 2)
                  : null,
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '\$${value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
