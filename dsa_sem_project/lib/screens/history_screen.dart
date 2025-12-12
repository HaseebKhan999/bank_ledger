import 'dart:convert'; // Required for parsing the JSON
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/bank_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BankProvider>(context);
    final transactions = provider.transactions;
    final fmt = NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ');
    final dateFmt = DateFormat('MMM dd, hh:mm a');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Enter Transaction ID...",
            border: InputBorder.none,
          ),
          onSubmitted: (value) => _performSearch(context, provider, value),
        )
            : const Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) _searchController.clear();
                _isSearching = !_isSearching;
              });
            },
          ),
          if (!_isSearching)
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              tooltip: "Sort By",
              onSelected: (value) {
                if (value == 'date') provider.sortHistoryByDate();
                if (value == 'amount') provider.sortHistoryByAmount();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'date', child: Text("Sort by Date (Newest)")),
                const PopupMenuItem(value: 'amount', child: Text("Sort by Amount (Highest)")),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Transactions:", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(
                  "${provider.totalTransactions}",
                  style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  const Text("No transactions yet"),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: transactions.length,
              separatorBuilder: (ctx, i) => Divider(color: Colors.grey.shade100),
              itemBuilder: (ctx, i) {
                final item = transactions[i];
                final isDeposit = item.type == 'deposit';

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: isDeposit ? Colors.green.shade50 : Colors.red.shade50,
                    child: Icon(
                      isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isDeposit ? Colors.green : Colors.red,
                      size: 24,
                    ),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "#${item.id}",
                          style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade700, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.description.isEmpty
                              ? (isDeposit ? "Deposit" : "Withdrawal")
                              : item.description,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(dateFmt.format(item.timestamp)),
                  trailing: Text(
                    "${isDeposit ? '+' : '-'} ${fmt.format(item.amount)}",
                    style: TextStyle(
                      color: isDeposit ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED SEARCH LOGIC FOR PRETTY UI ---
  void _performSearch(BuildContext context, BankProvider provider, String query) {
    final id = int.tryParse(query);
    if (id != null) {
      final rawResult = provider.searchTransaction(id);

      if (rawResult == null) {
        _showSimpleDialog(context, "Not Found", "Transaction #$id could not be found.");
        return;
      }

      // Check if it's our local record string
      if (rawResult.startsWith("Local Record")) {
        _showSimpleDialog(context, "Transaction #$id", rawResult);
        return;
      }

      // Try to parse JSON to make it look nice
      try {
        final Map<String, dynamic> data = jsonDecode(rawResult);
        _showPrettyTransactionDialog(context, id, data);
      } catch (e) {
        // If it's not JSON (just a plain string), show it as text
        _showSimpleDialog(context, "Transaction #$id", rawResult);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid numeric ID")),
      );
    }
  }

  // Helper for nice JSON display
  void _showPrettyTransactionDialog(BuildContext context, int id, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Colors.blue),
            const SizedBox(width: 10),
            Text("Transaction #$id", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            // Capitalize keys (e.g., "amount" -> "Amount")
            String key = entry.key[0].toUpperCase() + entry.key.substring(1);
            String value = entry.value.toString();

            // Format amount if detected
            if (key.toLowerCase() == "amount") {
              double? val = double.tryParse(value);
              if (val != null) {
                value = NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ').format(val);
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "$key:",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                  ),
                  Expanded(
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close"))],
      ),
    );
  }
}