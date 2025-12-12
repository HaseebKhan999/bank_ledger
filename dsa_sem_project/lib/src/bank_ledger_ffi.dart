import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

/// Dart wrapper for your BankLedger C++ DLL
class BankLedgerFFI {
  late final DynamicLibrary _dll;

  // FFI function typedefs
  late final Pointer<Void> Function(double) _createLedger;
  late final void Function(Pointer<Void>) _deleteLedger;
  late final int Function(Pointer<Void>, double, Pointer<Utf8>) _addDeposit;
  late final int Function(Pointer<Void>, double, Pointer<Utf8>) _addWithdrawal;
  late final int Function(Pointer<Void>) _undoLastTransaction;
  late final double Function(Pointer<Void>) _getCurrentBalance;
  late final int Function(Pointer<Void>) _canUndo;
  late final int Function(Pointer<Void>) _getTransactionCount;
  late final int Function(Pointer<Void>) _sortTransactionsByDate;
  late final int Function(Pointer<Void>) _sortTransactionsByAmount;
  late final Pointer<Utf8> Function(Pointer<Void>, int) _searchTransactionByID;
  late final Pointer<Utf8> Function() _getLastMessage;

  /// Load the DLL
  BankLedgerFFI(String dllPath) {
    if (!File(dllPath).existsSync()) {
      throw Exception('DLL not found at path: $dllPath');
    }

    _dll = DynamicLibrary.open(dllPath);

    // Bind functions
    _createLedger =
        _dll.lookupFunction<Pointer<Void> Function(Double), Pointer<Void> Function(double)>('createBankLedger');
    _deleteLedger =
        _dll.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('deleteBankLedger');
    _addDeposit = _dll.lookupFunction<Int32 Function(Pointer<Void>, Double, Pointer<Utf8>),
        int Function(Pointer<Void>, double, Pointer<Utf8>)>('addDeposit');
    _addWithdrawal = _dll.lookupFunction<Int32 Function(Pointer<Void>, Double, Pointer<Utf8>),
        int Function(Pointer<Void>, double, Pointer<Utf8>)>('addWithdrawal');
    _undoLastTransaction =
        _dll.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('undoLastTransaction');
    _getCurrentBalance =
        _dll.lookupFunction<Double Function(Pointer<Void>), double Function(Pointer<Void>)>('getCurrentBalance');
    _canUndo = _dll.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('canUndo');
    _getTransactionCount =
        _dll.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('getTransactionCount');
    _sortTransactionsByDate =
        _dll.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('sortTransactionsByDate');
    _sortTransactionsByAmount =
        _dll.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('sortTransactionsByAmount');
    _searchTransactionByID = _dll.lookupFunction<Pointer<Utf8> Function(Pointer<Void>, Int32),
        Pointer<Utf8> Function(Pointer<Void>, int)>('searchTransactionByID');
    _getLastMessage =
        _dll.lookupFunction<Pointer<Utf8> Function(), Pointer<Utf8> Function()>('getLastMessage');
  }

  /// Create a new ledger
  Pointer<Void> createLedger(double initialBalance) => _createLedger(initialBalance);

  /// Delete a ledger
  void deleteLedger(Pointer<Void> ledger) => _deleteLedger(ledger);

  /// Deposit
  bool addDeposit(Pointer<Void> ledger, double amount, String description) {
    final ptr = description.toNativeUtf8();
    final result = _addDeposit(ledger, amount, ptr) != 0;
    malloc.free(ptr);
    return result;
  }

  /// Withdraw
  bool addWithdrawal(Pointer<Void> ledger, double amount, String description) {
    final ptr = description.toNativeUtf8();
    final result = _addWithdrawal(ledger, amount, ptr) != 0;
    malloc.free(ptr);
    return result;
  }

  /// Undo last transaction
  bool undoLastTransaction(Pointer<Void> ledger) => _undoLastTransaction(ledger) != 0;

  /// Get current balance
  double getCurrentBalance(Pointer<Void> ledger) => _getCurrentBalance(ledger);

  /// Check if undo is available
  bool canUndo(Pointer<Void> ledger) => _canUndo(ledger) != 0;

  /// Transaction count
  int getTransactionCount(Pointer<Void> ledger) => _getTransactionCount(ledger);

  /// Sort transactions
  bool sortTransactionsByDate(Pointer<Void> ledger) => _sortTransactionsByDate(ledger) != 0;
  bool sortTransactionsByAmount(Pointer<Void> ledger) => _sortTransactionsByAmount(ledger) != 0;

  /// Search transaction by ID (returns JSON string)
  String searchTransactionByID(Pointer<Void> ledger, int id) =>
      _searchTransactionByID(ledger, id).toDartString();

  /// Last operation message
  String getLastMessage() => _getLastMessage().toDartString();
}
