import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped;

  const ExpenseTile({
    Key? key,
    required this.amount,
    required this.name,
    required this.dateTime,
    required this.deleteTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //Delete button
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(name),
            subtitle:
                Text('${dateTime.day} / ${dateTime.month} / ${dateTime.year}'),
            trailing: Text('$amount €'),
          ),
          const Divider(), // Ajout d'une ligne de division
        ],
      ),
    );
  }
}

class EmptyExpenseBlock extends StatelessWidget {
  const EmptyExpenseBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Aucune dépense enregistrée',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
