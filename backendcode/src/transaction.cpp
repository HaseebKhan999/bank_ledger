#include "../include/transaction.h"
#include <iostream>
#include <iomanip>

Transaction::Transaction(int id, const std::string& type, double amount,
                         const std::string& desc, double balanceAfter)
{
    this->id = id;
    this->type = type;
    this->amount = amount;
    this->description = desc;
    this->balanceAfter = balanceAfter;
    this->timestamp = time(nullptr);
}

void Transaction::display() const {
    std::cout << std::fixed << std::setprecision(2);
    std::cout << "ID: " << id << " | ";
    std::cout << "Type: " << type << " | ";
    std::cout << "Amount: $" << amount << " | ";
    std::cout << "Description: " << description << " | ";
    std::cout << "Balance: $" << balanceAfter << "\n";
}
