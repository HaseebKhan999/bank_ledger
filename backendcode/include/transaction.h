#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <string>
#include <ctime>

class Transaction {
public:
    int id;
    std::string type;          // "DEPOSIT" or "WITHDRAWAL"
    double amount;
    std::string description;
    time_t timestamp;
    double balanceAfter;

    Transaction(int id, const std::string& type, double amount,
                const std::string& desc, double balanceAfter);

    void display() const;
};

#endif
