#include "include/bank_ledger.h"
#include <iostream>
#include <iomanip>
#include <limits>
#include <chrono>
#include <vector>

using namespace std;
using namespace std::chrono;

// -------------------- Function Prototypes --------------------
void displayMenu();
void pause();
void runCorrectnessTests();
void runPerformanceAnalysis();

// -------------------- MAIN --------------------
int main() {
    cout << "========================================\n";
    cout << "   BANK LEDGER WITH UNDO FEATURE\n";
    cout << "     DSA Project - Phase 2\n";
    cout << "========================================\n\n";

    cout << "1. Run Interactive Bank Ledger\n";
    cout << "2. Run Correctness Test Cases\n";
    cout << "3. Run Performance Analysis (Big-O)\n";
    cout << "Enter choice: ";

    int mode;
    cin >> mode;

    if (mode == 2) {
        runCorrectnessTests();
        return 0;
    }

    if (mode == 3) {
        runPerformanceAnalysis();
        return 0;
    }

    // ---------------- Interactive Mode ----------------
    double initialBalance;
    cout << "\nEnter initial balance: $";
    cin >> initialBalance;

    BankLedger ledger(initialBalance);

    int choice;
    double amount;
    string description;
    int searchID;

    while (true) {
        displayMenu();
        cout << "\nEnter your choice (1-9): ";
        cin >> choice;
        cin.ignore(numeric_limits<streamsize>::max(), '\n');

        switch (choice) {
            case 1:
                cout << "Enter amount: $";
                cin >> amount;
                cin.ignore();
                cout << "Enter description: ";
                getline(cin, description);
                ledger.deposit(amount, description);
                break;

            case 2:
                cout << "Enter amount: $";
                cin >> amount;
                cin.ignore();
                cout << "Enter description: ";
                getline(cin, description);
                ledger.withdraw(amount, description);
                break;

            case 3:
                ledger.showHistory();
                break;

            case 4:
                ledger.showBalance();
                break;

            case 5:
                ledger.undo();
                break;

            case 6:
                ledger.sortByDate();
                ledger.showHistory();
                break;

            case 7:
                ledger.sortByAmount();
                ledger.showHistory();
                break;

            case 8:
                cout << "Enter transaction ID: ";
                cin >> searchID;
                ledger.searchByID(searchID);
                break;

            case 9:
                cout << "Exiting...\n";
                return 0;

            default:
                cout << "Invalid choice!\n";
        }
        pause();
    }
}

// -------------------- TEST CASES --------------------
void runCorrectnessTests() {
    cout << "\n===== CORRECTNESS TEST CASES =====\n";

    BankLedger ledger(1000);

    cout << "\n[Test 1] Deposit & Withdrawal\n";
    ledger.deposit(500, "Salary");
    ledger.withdraw(200, "Groceries");
    ledger.showBalance(); // Expected: 1300

    cout << "\n[Test 2] Undo Operation (Stack)\n";
    ledger.undo();
    ledger.showBalance(); // Expected: 1500

    cout << "\n[Test 3] Sorting & Searching\n";
    ledger.deposit(300, "Bonus");
    ledger.deposit(100, "Cash");
    ledger.sortByAmount();          // Merge Sort
    ledger.searchByID(2);           // Binary Search

    cout << "\nAll test cases executed successfully.\n";
}

// -------------------- PERFORMANCE ANALYSIS --------------------
void runPerformanceAnalysis() {
    cout << "\n===== PERFORMANCE ANALYSIS =====\n";
    vector<int> sizes = {1000, 10000, 100000};

    cout << left << setw(10) << "N"
         << setw(20) << "Insert (ms)"
         << setw(20) << "Sort (ms)"
         << setw(20) << "Search (ms)" << endl;

    for (int N : sizes) {
        double insertTime = 0, sortTime = 0, searchTime = 0;

        for (int run = 0; run < 3; run++) {
            BankLedger ledger(0);

            // -------- Insert --------
            auto start = high_resolution_clock::now();
            for (int i = 1; i <= N; i++) {
                ledger.deposit(i * 10, "Auto");
            }
            auto end = high_resolution_clock::now();
            insertTime += duration<double, milli>(end - start).count();

            // -------- Sort --------
            start = high_resolution_clock::now();
            ledger.sortByAmount();   // Merge Sort
            end = high_resolution_clock::now();
            sortTime += duration<double, milli>(end - start).count();

            // -------- Search --------
            start = high_resolution_clock::now();
            ledger.searchByID(N / 2); // Binary Search
            end = high_resolution_clock::now();
            searchTime += duration<double, milli>(end - start).count();
        }

        cout << setw(10) << N
             << setw(20) << insertTime / 3
             << setw(20) << sortTime / 3
             << setw(20) << searchTime / 3 << endl;
    }

    cout << "\nBig-O Summary:\n";
    cout << "Insertion (Linked List): O(1)\n";
    cout << "Undo (Stack): O(1)\n";
    cout << "Sorting (Merge Sort): O(n log n)\n";
    cout << "Searching (Binary Search): O(log n)\n";
}

// -------------------- UTILITIES --------------------
void displayMenu() {
    cout << "\n1. Add Deposit\n2. Add Withdrawal\n3. View History\n4. Balance\n";
    cout << "5. Undo\n6. Sort by Date\n7. Sort by Amount\n";
    cout << "8. Search by ID\n9. Exit\n";
}

void pause() {
    cout << "\nPress Enter to continue...";
    cin.get();
}
