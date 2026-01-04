import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final keys = data.keys.toList()..sort();
    return BarChart(
      BarChartData(
        barGroups: List.generate(keys.length, (i) {
          final day = keys[i];
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[day]!,
                color: data[day]! >= 0 ? Colors.green : Colors.red,
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, meta) {
                if (value.toInt() >= keys.length) return const SizedBox();
                return Text(
                  keys[value.toInt()].substring(5),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
