// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/bank_provider.dart';
import 'history_screen.dart';

final currencyFmt = NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ');

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BankProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu, color: Colors.blueGrey),
            tooltip: "History",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- BALANCE CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Balance", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    currencyFmt.format(provider.currentBalance),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.verified_user, color: Colors.greenAccent, size: 16),
                      const SizedBox(width: 5),
                      Text("Synced with C++ Backend", style: TextStyle(color: Colors.greenAccent.shade100, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- ACTIONS GRID ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _ActionButton(
                    title: "Deposit",
                    icon: Icons.arrow_downward_rounded,
                    color: Colors.green,
                    onTap: () => _showDialog(context, isDeposit: true),
                  ),
                  _ActionButton(
                    title: "Withdraw",
                    icon: Icons.arrow_upward_rounded,
                    color: Colors.redAccent,
                    onTap: () => _showDialog(context, isDeposit: false),
                  ),
                  _ActionButton(
                    title: "Undo Last",
                    icon: Icons.undo_rounded,
                    color: Colors.orange,
                    // Disable button visually if undo is not possible
                    isFab: false,
                    onTap: provider.canUndo ? () {
                      provider.performUndo();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.lastMessage), duration: const Duration(seconds: 1))
                      );
                    } : null,
                  ),
                  _ActionButton(
                    title: "Statement",
                    icon: Icons.receipt_long,
                    color: Colors.purple,
                    isFab: false,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, {required bool isDeposit}) {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(isDeposit ? "Add Funds" : "Withdraw Funds",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              // UPDATED LOGIC HERE:
              decoration: InputDecoration(
                  labelText: isDeposit ? "Source (e.g. Salary)" : "Reason (e.g. Car Payments)",
                  border: const OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountCtrl.text);
                if (amount != null) {
                  final provider = Provider.of<BankProvider>(context, listen: false);
                  if (isDeposit) {
                    provider.performDeposit(amount, descCtrl.text);
                  } else {
                    provider.performWithdrawal(amount, descCtrl.text);
                  }
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: isDeposit ? Colors.green : Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: Text(isDeposit ? "CONFIRM DEPOSIT" : "CONFIRM WITHDRAWAL"),
            )
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isFab;

  const _ActionButton({required this.title, required this.icon, required this.color, this.onTap, this.isFab = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: onTap == null ? Colors.grey.shade100 : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: onTap == null ? Colors.grey : color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: onTap == null ? Colors.grey : Colors.black87)),
          ],
        ),
      ),
    );
  }
}