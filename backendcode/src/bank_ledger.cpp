#include "../include/bank_ledger.h"
#include <iostream>
#include <iomanip>
#include <algorithm>
using namespace std;

BankLedger::BankLedger(double initialBalance) {
    balance = initialBalance;
    transactionID = 0;
    transactionList = new LinkedList();
    undoStack = new Stack(50);

    cout << "Bank Ledger initialized with balance: $"
         << fixed << setprecision(2) << balance << endl;
}

BankLedger::~BankLedger() {
    delete transactionList;
    delete undoStack;
}

void BankLedger::deposit(double amount, string description) {
    if (amount <= 0) {
        cout << "Error: Amount must be positive!" << endl;
        return;
    }

    balance += amount;
    transactionID++;

    Transaction* t = new Transaction(transactionID, "DEPOSIT", amount, description, balance);
    transactionList->insert(t);
    undoStack->push(new Transaction(*t));  // Push copy

    cout << "Deposit successful! New balance: $"
         << fixed << setprecision(2) << balance << endl;
}

void BankLedger::withdraw(double amount, string description) {
    if (amount <= 0) {
        cout << "Error: Amount must be positive!" << endl;
        return;
    }

    if (amount > balance) {
        cout << "Error: Insufficient balance!" << endl;
        cout << "Current balance: $" << fixed << setprecision(2) << balance << endl;
        return;
    }

    balance -= amount;
    transactionID++;

    Transaction* t = new Transaction(transactionID, "WITHDRAWAL", amount, description, balance);
    transactionList->insert(t);
    undoStack->push(new Transaction(*t));  // Push copy

    cout << "Withdrawal successful! New balance: $"
         << fixed << setprecision(2) << balance << endl;
}

void BankLedger::undo() {
    if (undoStack->isEmpty()) {
        cout << "Error: No transactions to undo!" << endl;
        return;
    }

    Transaction* lastTrans = undoStack->pop();
    if (!lastTrans) return;

    if (lastTrans->type == "DEPOSIT") {
        balance -= lastTrans->amount;
    } else {
        balance += lastTrans->amount;
    }

    Transaction* removed = transactionList->removeLast();
    if (removed) delete removed;

    delete lastTrans;

    cout << "Transaction undone successfully!" << endl;
    cout << "New balance: $" << fixed << setprecision(2) << balance << endl;
}

void BankLedger::showBalance() {
    cout << "\n=== Account Balance ===" << endl;
    cout << "Current Balance: $" << fixed << setprecision(2) << balance << endl;
    cout << "Total Transactions: " << transactionList->size() << endl;
    cout << "Available Undos: " << undoStack->size() << endl;
}

void BankLedger::showHistory() {
    transactionList->display();
}

void BankLedger::sortByDate() {
    transactionList->sortByDate();
    cout << "Transactions sorted by date." << endl;
}

void BankLedger::sortByAmount() {
    transactionList->sortByAmount();
    cout << "Transactions sorted by amount." << endl;
}

Transaction* BankLedger::searchByID(int id) {
    int n = transactionList->size();
    if (n == 0) {
        cout << "No transactions available." << endl;
        return nullptr;
    }

    Transaction** arr = transactionList->toArray();

    // Sort by ID for binary search
    sort(arr, arr + n, [](Transaction* a, Transaction* b) { return a->id < b->id; });

    int low = 0, high = n - 1;
    Transaction* result = nullptr;

    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (arr[mid]->id == id) {
            result = arr[mid];
            break;
        }
        if (arr[mid]->id < id) low = mid + 1;
        else high = mid - 1;
    }

    delete[] arr;

    if (!result) {
        cout << "Transaction with ID " << id << " not found." << endl;
        return nullptr;
    }

    cout << "\n=== Transaction Found ===" << endl;
    result->display();
    cout << "=========================\n";

    return result;
}

// ----------------------
// Getter implementations
// ----------------------
double BankLedger::getBalance() const {
    return balance;
}

bool BankLedger::canUndo() const {
    return !undoStack->isEmpty();
}

int BankLedger::getTransactionCount() const {
    return transactionList ? transactionList->size() : 0;
}
