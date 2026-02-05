import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const RevenueChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(
                e.key.toDouble(),
                e.value['revenue'].toDouble(),
              ))
                  .toList(),
              isCurved: true,
              color: Colors.teal,
              barWidth: 3,
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }
}
