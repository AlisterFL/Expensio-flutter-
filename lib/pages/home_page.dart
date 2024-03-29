import 'package:expensio/components/expense_summary.dart';
import 'package:expensio/components/expense_tile.dart';
import 'package:expensio/data/expense_data.dart';
import 'package:expensio/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseEuroController = TextEditingController();
  final newExpenseCentimesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  final TextEditingController dailyExpenseLimitController =
      TextEditingController();

  // Dans la méthode addNewExpense ou dans une autre méthode dédiée
  void setDailyExpenseLimit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Définir la limite de dépense quotidienne'),
        content: TextField(
          controller: dailyExpenseLimitController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Limite de dépense quotidienne",
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              double limit = double.parse(dailyExpenseLimitController.text);
              Provider.of<ExpenseData>(context, listen: false)
                  .addDailyExpenseLimit(limit);
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  //add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Ajouter une depense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name
              TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(
                  hintText: "Nom de la dépense",
                ),
              ),

              //expense amount
              Row(
                children: [
                  //euro
                  Expanded(
                    child: TextField(
                      controller: newExpenseEuroController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Euros",
                      ),
                    ),
                  ),

                  //centimes
                  Expanded(
                    child: TextField(
                      controller: newExpenseCentimesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Centimes",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: [
            //save button
            MaterialButton(onPressed: save, child: const Text('Enregistrer')),

            //cancel button
            MaterialButton(onPressed: cancel, child: const Text('Annuler')),
          ]),
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //Save
  void save() {
    //compilation euro et centimes
    int euros = int.parse(newExpenseEuroController.text);
    int centimes = int.parse(newExpenseCentimesController.text);
    String amount = '$euros.$centimes';
    //create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: amount,
      dateTime: DateTime.now(),
    );
    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //Clear
  void clear() {
    newExpenseCentimesController.clear();
    newExpenseEuroController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => setDailyExpenseLimit(context),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.monetization_on, color: Colors.white),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        body: ListView(
          children: [
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: const Text(
                'Toutes les dépenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            value.getAllExpenseList().isEmpty
                ? const Center(
                    child: Text(
                      'Aucune dépense enregistrée',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) => ExpenseTile(
                      name: value.getAllExpenseList()[index].name,
                      amount: value.getAllExpenseList()[index].amount,
                      dateTime: value.getAllExpenseList()[index].dateTime,
                      deleteTapped: (p0) =>
                          deleteExpense(value.getAllExpenseList()[index]),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
