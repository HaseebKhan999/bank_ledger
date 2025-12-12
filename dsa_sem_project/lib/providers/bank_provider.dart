import 'dart:convert';
import 'dart:io';
import 'dart:ffi'; // REQUIRED for Pointer types
import 'package:flutter/material.dart';

// Ensure these paths match your project structure
import '../src/bank_ledger_ffi.dart';
import '../models/transaction_model.dart';

class BankProvider extends ChangeNotifier {
  BankLedgerFFI? _ffi;
  Pointer<Void>? _ledger;

  double _currentBalance = 0.0;
  String _lastMessage = "Welcome";
  int _transactionIdCounter = 0; // Local counter for IDs

  // Local list mirrors C++ data for UI display
  List<TransactionItem> _transactions = [];

  // --- Getters ---
  double get currentBalance => _currentBalance;
  String get lastMessage => _lastMessage;
  List<TransactionItem> get transactions => List.unmodifiable(_transactions);
  bool get isInitialized => _ledger != null;

  // --- FIX: USE LOCAL LIST LENGTH ---
  // Previously: return _ffi!.getTransactionCount(_ledger!);
  // Now: return _transactions.length;
  // This correctly counts the "Account Opened" record + all C++ transactions.
  int get totalTransactions => _transactions.length;

  bool get canUndo {
    if (_ledger == null || _ffi == null) return false;
    return _ffi!.canUndo(_ledger!);
  }

  // --- INITIALIZATION ---
  void initializeLedger(double startingBalance) {
    String libName = 'bank_ledger.dll';

    // Debug info
    print("DEBUG: App is running in: ${Directory.current.path}");
    bool exists = File(libName).existsSync();
    if (!exists) {
      print("⚠️ CRITICAL: DLL not found. Copy 'bank_ledger.dll' to root.");
    }

    try {
      _ffi = BankLedgerFFI(libName);
      print("✅ DEBUG: DLL Loaded Successfully!");

      _ledger = _ffi!.createLedger(startingBalance);

      _currentBalance = startingBalance;
      _transactions.clear();
      _transactionIdCounter = 0;

      // Add initial entry (ID: 1) - Local only
      _transactionIdCounter++;
      _transactions.add(TransactionItem(
          id: _transactionIdCounter,
          type: "deposit",
          amount: startingBalance,
          description: "Account Opened",
          timestamp: DateTime.now()));

      notifyListeners();
    } catch (e) {
      print("❌ DLL CRASH: $e");
      _lastMessage = "System Error: DLL failed to load.";
      notifyListeners();
    }
  }

  // --- CORE TRANSACTIONS ---
  void performDeposit(double amount, String desc) {
    if (_ledger == null) return;

    bool success = _ffi!.addDeposit(_ledger!, amount, desc);
    if (success) {
      _transactionIdCounter++;
      _transactions.insert(0, TransactionItem(
          id: _transactionIdCounter,
          type: 'deposit',
          amount: amount,
          description: desc,
          timestamp: DateTime.now()));
      _lastMessage = "Deposit Successful";
      _refreshData();
    } else {
      _lastMessage = "Deposit Failed";
      notifyListeners();
    }
  }

  void performWithdrawal(double amount, String desc) {
    if (_ledger == null) return;

    bool success = _ffi!.addWithdrawal(_ledger!, amount, desc);
    if (success) {
      _transactionIdCounter++;
      _transactions.insert(0, TransactionItem(
          id: _transactionIdCounter,
          type: 'withdrawal',
          amount: amount,
          description: desc,
          timestamp: DateTime.now()));
      _lastMessage = "Withdrawal Successful";
      _refreshData();
    } else {
      _lastMessage = _ffi!.getLastMessage();
      notifyListeners();
    }
  }

  void performUndo() {
    if (_ledger == null) return;

    bool success = _ffi!.undoLastTransaction(_ledger!);
    if (success) {
      if (_transactions.isNotEmpty) {
        _transactions.removeAt(0); // Remove newest from UI
        _transactionIdCounter--;
      }
      _lastMessage = "Transaction Undone";
      _refreshData();
    } else {
      _lastMessage = _ffi!.getLastMessage();
      notifyListeners();
    }
  }

  // --- SORTING ---
  void sortHistoryByDate() {
    if (_ledger == null) return;
    _ffi!.sortTransactionsByDate(_ledger!);
    _transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  void sortHistoryByAmount() {
    if (_ledger == null) return;
    _ffi!.sortTransactionsByAmount(_ledger!);
    _transactions.sort((a, b) => b.amount.compareTo(a.amount));
    notifyListeners();
  }

  // --- SEARCH ---
  String? searchTransaction(int id) {
    if (_ledger == null) return null;

    if (id == 1) {
      return "Local Record: Account Initialized (Not in Backend)";
    }

    try {
      int backendIndex = id - 2;

      if (backendIndex < 0) {
        return "Invalid ID: This transaction does not exist in the backend.";
      }

      String result = _ffi!.searchTransactionByID(_ledger!, backendIndex);

      if (result.isEmpty || result == "{}" || result.toLowerCase().contains("not found")) {
        String retry = _ffi!.searchTransactionByID(_ledger!, id - 1);
        if (!retry.toLowerCase().contains("not found") && retry.isNotEmpty) {
          return retry;
        }
        return null;
      }
      return result;
    } catch (e) {
      return "Error searching ID: $e";
    }
  }

  // --- HELPERS ---
  void _refreshData() {
    _currentBalance = _ffi!.getCurrentBalance(_ledger!);
    notifyListeners();
  }

  @override
  void dispose() {
    if (_ledger != null && _ffi != null) {
      _ffi!.deleteLedger(_ledger!);
    }
    super.dispose();
  }
}