#include "../include/bank_ledger.h"
#include <string>
#include <sstream>
#include <iomanip>

#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#else
#define DLL_EXPORT
#endif

// Global message buffer
static std::string lastMessage = "";

// Helper to set messages
void setMessage(const std::string& msg) {
    lastMessage = msg;
}

extern "C" {

    // Create BankLedger
    DLL_EXPORT void* createBankLedger(double initialBalance) {
        BankLedger* ledger = new BankLedger(initialBalance);
        setMessage("Bank ledger created successfully.");
        return ledger;
    }

    // Delete BankLedger
    DLL_EXPORT void deleteBankLedger(void* ledger) {
        if (ledger) {
            delete (BankLedger*)ledger;
            setMessage("Bank ledger deleted.");
        }
    }

    // Deposit
    DLL_EXPORT int addDeposit(void* ledger, double amount, const char* description) {
        if (!ledger || !description) {
            setMessage("Error: Invalid deposit parameters.");
            return 0;
        }

        BankLedger* bank = (BankLedger*)ledger;
        bank->deposit(amount, std::string(description));

        setMessage("Deposit successful. New Balance: $" + std::to_string(bank->getBalance()));
        return 1;
    }

    // Withdrawal
    DLL_EXPORT int addWithdrawal(void* ledger, double amount, const char* description) {
        if (!ledger || !description) {
            setMessage("Error: Invalid withdrawal parameters.");
            return 0;
        }

        BankLedger* bank = (BankLedger*)ledger;
        double oldBalance = bank->getBalance();
        bank->withdraw(amount, std::string(description));
        double newBalance = bank->getBalance();

        if (newBalance == oldBalance) {
            setMessage("Withdrawal failed: Insufficient balance.");
            return 0;
        }

        setMessage("Withdrawal successful. New Balance: $" + std::to_string(newBalance));
        return 1;
    }

    // Undo last transaction
    DLL_EXPORT int undoLastTransaction(void* ledger) {
        if (!ledger) {
            setMessage("Error: Ledger does not exist.");
            return 0;
        }

        BankLedger* bank = (BankLedger*)ledger;
        if (!bank->canUndo()) {
            setMessage("Error: No transactions to undo.");
            return 0;
        }

        bank->undo();
        setMessage("Undo successful. New Balance: $" + std::to_string(bank->getBalance()));
        return 1;
    }

    // Get current balance
    DLL_EXPORT double getCurrentBalance(void* ledger) {
        if (!ledger) {
            setMessage("Error: Ledger not found.");
            return 0.0;
        }
        BankLedger* bank = (BankLedger*)ledger;
        return bank->getBalance();
    }

    // Check if undo is available
    DLL_EXPORT int canUndo(void* ledger) {
        if (!ledger) return 0;
        BankLedger* bank = (BankLedger*)ledger;
        return bank->canUndo() ? 1 : 0;
    }

    // Get transaction count
    DLL_EXPORT int getTransactionCount(void* ledger) {
        if (!ledger) return 0;
        BankLedger* bank = (BankLedger*)ledger;
        return bank->getTransactionCount();
    }

    // Sort transactions by date
    DLL_EXPORT int sortTransactionsByDate(void* ledger) {
        if (!ledger) return 0;
        BankLedger* bank = (BankLedger*)ledger;
        bank->sortByDate();
        setMessage("Transactions sorted by date (Merge Sort).");
        return 1;
    }

    // Sort transactions by amount
    DLL_EXPORT int sortTransactionsByAmount(void* ledger) {
        if (!ledger) return 0;
        BankLedger* bank = (BankLedger*)ledger;
        bank->sortByAmount();
        setMessage("Transactions sorted by amount (Merge Sort).");
        return 1;
    }

    // Search transaction by ID
    DLL_EXPORT const char* searchTransactionByID(void* ledger, int transactionID) {
        static std::string resultBuffer;

        if (!ledger) {
            setMessage("Error: Ledger not found.");
            resultBuffer.clear();
            return resultBuffer.c_str();
        }

        BankLedger* bank = (BankLedger*)ledger;
        Transaction* found = bank->searchByID(transactionID);

        if (!found) {
            setMessage("Transaction not found (Binary Search).");
            resultBuffer.clear();
            return resultBuffer.c_str();
        }

        // Format transaction as JSON-like string
        std::ostringstream oss;
        oss << std::fixed << std::setprecision(2);
        oss << "{"
            << "\"id\":" << found->id << ","
            << "\"type\":\"" << found->type << "\","
            << "\"amount\":" << found->amount << ","
            << "\"description\":\"" << found->description << "\","
            << "\"timestamp\":" << found->timestamp << ","
            << "\"balanceAfter\":" << found->balanceAfter
            << "}";

        resultBuffer = oss.str();
        setMessage("Transaction found successfully (Binary Search).");
        return resultBuffer.c_str();
    }

    // Get last message
    DLL_EXPORT const char* getLastMessage() {
        return lastMessage.c_str();
    }

} // extern "C"
