import 'package:expensio/bar%20graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double lunAmount;
  final double marAmount;
  final double merAmount;
  final double jeuAmount;
  final double venAmount;
  final double samAmount;
  final double dimAmount;
  final double dailyLimit;

  const MyBarGraph({
    Key? key,
    required this.maxY,
    required this.lunAmount,
    required this.marAmount,
    required this.merAmount,
    required this.jeuAmount,
    required this.venAmount,
    required this.samAmount,
    required this.dimAmount,
    required this.dailyLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialisation de la databar
    BarData myBarData = BarData(
      lunAmount: lunAmount,
      marAmount: marAmount,
      merAmount: merAmount,
      jeuAmount: jeuAmount,
      venAmount: venAmount,
      samAmount: samAmount,
      dimAmount: dimAmount,
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _buildBarGroup(lunAmount, 0),
          _buildBarGroup(marAmount, 1),
          _buildBarGroup(merAmount, 2),
          _buildBarGroup(jeuAmount, 3),
          _buildBarGroup(venAmount, 4),
          _buildBarGroup(samAmount, 5),
          _buildBarGroup(dimAmount, 6),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(double amount, int xValue) {
    return BarChartGroupData(
      x: xValue,
      barRods: [
        BarChartRodData(
          toY: amount,
          color: calculateBarColor(amount, dailyLimit),
          width: 25,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Color calculateBarColor(double amount, double? dailyLimit) {
    if (dailyLimit == null || dailyLimit == 0) {
      return Colors.blue;
    }

    double percentage = amount / dailyLimit;

    if (percentage <= 0.7) {
      return Colors.blue;
    } else if (percentage <= 1.0) {
      return Colors.blue.shade600;
    } else if (percentage <= 1.3) {
      return Colors.blue.shade700;
    } else if (percentage <= 1.5) {
      return Colors.blue.shade800;
    } else {
      return Colors.blue.shade900;
    }
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('L', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('M', style: style);
      break;
    case 3:
      text = const Text('J', style: style);
      break;
    case 4:
      text = const Text('V', style: style);
      break;
    case 5:
      text = const Text('S', style: style);
      break;
    case 6:
      text = const Text('D', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
