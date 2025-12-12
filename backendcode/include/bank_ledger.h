#ifndef BANK_LEDGER_H
#define BANK_LEDGER_H

#include "transaction.h"
#include "linked_list.h"
#include "stack.h"
#include <string>

class BankLedger {
private:
    double balance;
    int transactionID;
    LinkedList* transactionList;
    Stack* undoStack;

public:
    BankLedger(double initialBalance = 0.0);
    ~BankLedger();

    // Core functions
    void deposit(double amount, std::string description);
    void withdraw(double amount, std::string description);
    void undo();
    void showBalance();
    void showHistory();

    // Sorting
    void sortByDate();
    void sortByAmount();

    // Searching
    Transaction* searchByID(int id);

    // ----------------------
    // Getter functions
    // ----------------------
    double getBalance() const;
    bool canUndo() const;
    int getTransactionCount() const;
};

#endif
