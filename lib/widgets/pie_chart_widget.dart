import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finager/providers/category_analytics_provider.dart';

class CategoryPieChart extends StatelessWidget {
  final List<CategoryAnalytics> analytics;
  final String title;

  const CategoryPieChart({
    super.key,
    required this.analytics,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final total = analytics.fold<double>(0.0, (sum, item) => sum + item.total);
    final hasData = total > 0;

    List<Color> chartColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child:
                  hasData
                      ? PieChart(
                        PieChartData(
                          sections:
                              analytics.asMap().entries.map((entry) {
                                final index = entry.key;
                                final data = entry.value;
                                final percentage = (data.total / total * 100)
                                    .toStringAsFixed(1);
                                final shortName =
                                    data.category.name.length > 10
                                        ? '${data.category.name.substring(0, 10)}...'
                                        : data.category.name;

                                return PieChartSectionData(
                                  value: data.total,
                                  color:
                                      chartColors[index % chartColors.length],
                                  title:
                                      "$shortName\n${data.total.toStringAsFixed(0)} ($percentage%)",
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                        ),
                      )
                      : const Center(child: Text("No data available")),
            ),
            const SizedBox(height: 20),
            if (hasData)
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children:
                    analytics.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final shortName =
                          data.category.name.length > 15
                              ? '${data.category.name.substring(0, 15)}...'
                              : data.category.name;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: chartColors[index % chartColors.length],
                          ),
                          const SizedBox(width: 4),
                          Text(shortName, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
