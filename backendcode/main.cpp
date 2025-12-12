#include "include/bank_ledger.h"
#include <iostream>
#include <iomanip>
#include <limits>
using namespace std;

void displayMenu();
void pause();

int main() {
    // Display welcome message
    cout << "========================================" << endl;
    cout << "   BANK LEDGER WITH UNDO FEATURE" << endl;
    cout << "     DSA Project - Phase 2" << endl;
    cout << "========================================" << endl;
    cout << endl;
    
    // Get initial balance
    double initialBalance;
    cout << "Enter initial balance: $";
    cin >> initialBalance;
    
    // Create bank ledger object
    BankLedger ledger(initialBalance);
    
    int choice;
    double amount;
    string description;
    int searchID;
    
    while (true) {
        displayMenu();
        cout << "\nEnter your choice (1-9): ";
        cin >> choice;
        
        // Clear input buffer
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        
        cout << endl;
        
        switch (choice) {
            case 1: {
                // Add Deposit
                cout << "--- ADD DEPOSIT ---" << endl;
                cout << "Enter amount: $";
                cin >> amount;
                cin.ignore(numeric_limits<streamsize>::max(), '\n');
                
                cout << "Enter description: ";
                getline(cin, description);
                
                ledger.deposit(amount, description);
                break;
            }
            
            case 2: {
                // Add Withdrawal
                cout << "--- ADD WITHDRAWAL ---" << endl;
                cout << "Enter amount: $";
                cin >> amount;
                cin.ignore(numeric_limits<streamsize>::max(), '\n');
                
                cout << "Enter description: ";
                getline(cin, description);
                
                ledger.withdraw(amount, description);
                break;
            }
            
            case 3: {
                // View Transaction History
                cout << "--- TRANSACTION HISTORY ---" << endl;
                ledger.showHistory();
                break;
            }
            
            case 4: {
                // Check Balance
                ledger.showBalance();
                break;
            }
            
            case 5: {
                // Undo Last Transaction
                cout << "--- UNDO LAST TRANSACTION ---" << endl;

                char confirm;
                cout << "Are you sure you want to undo? (y/n): ";
                cin >> confirm;
                
                if (confirm == 'y' || confirm == 'Y') {
                    ledger.undo();
                } else {
                    cout << "Undo cancelled." << endl;
                }

                break;
            }
            
            case 6: {
                // Sort by Date
                cout << "--- SORT TRANSACTIONS BY DATE ---" << endl;
                ledger.sortByDate();
                cout << "\nSorted transaction history:" << endl;
                ledger.showHistory();
                break;
            }
            
            case 7: {
                // Sort by Amount
                cout << "--- SORT TRANSACTIONS BY AMOUNT ---" << endl;
                ledger.sortByAmount();
                cout << "\nSorted transaction history:" << endl;
                ledger.showHistory();
                break;
            }
            
            case 8: {
                // Search by Transaction ID
                cout << "--- SEARCH TRANSACTION BY ID ---" << endl;
                cout << "Enter transaction ID to search: ";
                cin >> searchID;
                
                Transaction* found = ledger.searchByID(searchID);
                
                if (found == NULL) {
                    cout << "\nTransaction not found!" << endl;
                }
                break;
            }
            
            case 9: {
                // Exit
                cout << "\n========================================" << endl;
                cout << "Thank you for using Bank Ledger!" << endl;
                cout << "Final Balance: " << endl;
                ledger.showBalance();  // safe replacement
                cout << "========================================" << endl;
                return 0;
            }
            
            default:
                cout << "Invalid choice! Please try again." << endl;
        }
        
        pause();
    }
    
    return 0;
}

void displayMenu() {
    cout << "\n========================================" << endl;
    cout << "              MAIN MENU" << endl;
    cout << "========================================" << endl;
    cout << "1. Add Deposit" << endl;
    cout << "2. Add Withdrawal" << endl;
    cout << "3. View Transaction History" << endl;
    cout << "4. Check Balance" << endl;
    cout << "5. Undo Last Transaction" << endl;
    cout << "6. Sort by Date (Merge Sort)" << endl;
    cout << "7. Sort by Amount (Merge Sort)" << endl;
    cout << "8. Search by Transaction ID (Binary Search)" << endl;
    cout << "9. Exit" << endl;
    cout << "========================================" << endl;
}

void pause() {
    cout << "\nPress Enter to continue...";
    cin.get();
}
