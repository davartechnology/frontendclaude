import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final double amount;
  final bool isPositive;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPositive ? Colors.green[900] : Colors.red[900],
        child: Icon(
          icon,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        date,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: Text(
        '${isPositive ? '+' : '-'}${Formatters.formatCurrency(amount)}',
        style: TextStyle(
          color: isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}