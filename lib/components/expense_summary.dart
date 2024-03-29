import 'package:expensio/bar%20graph/bar_graph.dart';
import 'package:expensio/data/expense_data.dart';
import 'package:expensio/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  //calculer le max pour bar graph
  double calculateMax(
    ExpenseData value,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
    String sunday,
  ) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
    ];

    // ranger par ordre croissant
    values.sort();
    // prendre la + grande valeur (+0.1 pour pas etre full)
    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  // total de la semaine calcul
  String calculatedWeekTotal(
    ExpenseData value,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
    String sunday,
  ) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get ddmmyyyy pour chaque jour
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    // Récupérer la limite quotidienne depuis ExpenseData
    double dailyLimit = Provider.of<ExpenseData>(context).expenseLimit;

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          // lignes total semaine et limite dépense
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total de la semaine
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total de la semaine:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          ' ${calculatedWeekTotal(value, monday, tuesday, wednesday, thursday, friday, saturday, sunday)} €',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Limite de dépense quotidienne
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Limite quotidienne:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          ' ${value.expenseLimit} €',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // bar graph
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(value, monday, tuesday, wednesday, thursday,
                  friday, saturday, sunday),
              lunAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
              marAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
              merAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
              jeuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
              venAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
              samAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
              dimAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
              dailyLimit: dailyLimit,
            ),
          ),
        ],
      ),
    );
  }
}
