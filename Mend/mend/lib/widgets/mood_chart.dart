import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import '../constants/app_constants.dart';

enum ChartPeriod { week, month, year }

class MoodChart extends StatelessWidget {
  final List<MoodEntry> entries;
  final ChartPeriod period;

  const MoodChart({super.key, required this.entries, required this.period});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _buildEmptyChart(context);
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _getBottomInterval(),
              getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300),
        ),
        minX: 0,
        maxX: _getMaxX(),
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: _generateSpots(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppConstants.primaryColor.withValues(alpha: 0.8),
                AppConstants.primaryColor,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppConstants.primaryColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor.withValues(alpha: 0.3),
                  AppConstants.primaryColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'Intensity: ${spot.y.toInt()}/10',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'No data for this period',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Start logging moods to see your chart',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    if (entries.isEmpty) return [];

    final sortedEntries = List<MoodEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = <FlSpot>[];

    switch (period) {
      case ChartPeriod.week:
        for (int i = 0; i < 7; i++) {
          final date = DateTime.now().subtract(Duration(days: 6 - i));
          final dayEntries =
              sortedEntries
                  .where(
                    (entry) =>
                        entry.date.year == date.year &&
                        entry.date.month == date.month &&
                        entry.date.day == date.day,
                  )
                  .toList();

          if (dayEntries.isNotEmpty) {
            final avgIntensity =
                dayEntries.fold<double>(
                  0,
                  (sum, entry) => sum + entry.intensity,
                ) /
                dayEntries.length;
            spots.add(FlSpot(i.toDouble(), avgIntensity));
          }
        }
        break;

      case ChartPeriod.month:
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

        for (int i = 1; i <= daysInMonth; i++) {
          final date = DateTime(now.year, now.month, i);
          final dayEntries =
              sortedEntries
                  .where(
                    (entry) =>
                        entry.date.year == date.year &&
                        entry.date.month == date.month &&
                        entry.date.day == date.day,
                  )
                  .toList();

          if (dayEntries.isNotEmpty) {
            final avgIntensity =
                dayEntries.fold<double>(
                  0,
                  (sum, entry) => sum + entry.intensity,
                ) /
                dayEntries.length;
            spots.add(FlSpot((i - 1).toDouble(), avgIntensity));
          }
        }
        break;

      case ChartPeriod.year:
        for (int i = 1; i <= 12; i++) {
          final monthEntries =
              sortedEntries.where((entry) => entry.date.month == i).toList();

          if (monthEntries.isNotEmpty) {
            final avgIntensity =
                monthEntries.fold<double>(
                  0,
                  (sum, entry) => sum + entry.intensity,
                ) /
                monthEntries.length;
            spots.add(FlSpot((i - 1).toDouble(), avgIntensity));
          }
        }
        break;
    }

    return spots;
  }

  double _getMaxX() {
    switch (period) {
      case ChartPeriod.week:
        return 6;
      case ChartPeriod.month:
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        return (daysInMonth - 1).toDouble();
      case ChartPeriod.year:
        return 11;
    }
  }

  double _getBottomInterval() {
    switch (period) {
      case ChartPeriod.week:
        return 1;
      case ChartPeriod.month:
        return 5;
      case ChartPeriod.year:
        return 1;
    }
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    String text;

    switch (period) {
      case ChartPeriod.week:
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        text = days[value.toInt() % 7];
        break;
      case ChartPeriod.month:
        text = (value.toInt() + 1).toString();
        break;
      case ChartPeriod.year:
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        text = months[value.toInt() % 12];
        break;
    }

    return Text(
      text,
      style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12),
    );
  }
}
