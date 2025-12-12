// Location: lib/models/transaction_model.dart

class TransactionItem {
  final int id; // Added ID field
  final String type; // "deposit" or "withdrawal"
  final double amount;
  final String description;
  final DateTime timestamp;

  TransactionItem({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  });
}