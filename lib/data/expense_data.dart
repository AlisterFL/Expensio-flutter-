import 'package:expensio/data/hive_database.dart';
import 'package:expensio/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import '../models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  double _expenseLimit = 0; // montant limite de base

  //list of ALL expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    // if there exists data, get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday (mon, tues, etc) from a dateTIme object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mer';
      case 4:
        return 'Jeu';
      case 5:
        return 'Ven';
      case 6:
        return 'Sam';
      case 7:
        return 'Dim';
      default:
        return '';
    }
  }

  //get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get toadys date
    DateTime today = DateTime.now();

    //go backward from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Lun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  // Contrôleur pour la limite de dépense quotidienne
  final TextEditingController dailyExpenseLimitController =
      TextEditingController();

  // Méthode pour récupérer le montant limite
  double get expenseLimit => _expenseLimit;

  // Méthode pour mettre à jour le montant limite
  void updateExpenseLimit(double limit) {
    _expenseLimit = limit;
    notifyListeners();
  }

  // Méthode pour ajouter une limite de dépense quotidienne
  void addDailyExpenseLimit(double limit) {
    _expenseLimit = limit;
    notifyListeners();
  }

  Map<String, double> calculateDailyExpensePercentages(double dailyLimit) {
    Map<String, double> dailyExpensePercentages = {};

    Map<String, double> dailyExpenseSummary = calculateDailyExpenseSummary();
    for (var entry in dailyExpenseSummary.entries) {
      double percentage = entry.value / dailyLimit;
      dailyExpensePercentages[entry.key] = percentage;
    }

    return dailyExpensePercentages;
  }
}
