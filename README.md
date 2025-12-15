Bank Ledger System with Undo Feature
Data Structures & Algorithms Project (C++ Backend)
Project Overview

This project is a Bank Ledger Management System developed to demonstrate the practical use of Data Structures and Algorithms in a real-world scenario.
The system records financial transactions, allows undoing operations, and supports sorting and searching efficiently.

The core focus of this project is on DSA concepts, while a lightweight Flutter frontend is connected only to visualize the results using FFI.

Objectives of the Project

Apply fundamental data structures in a meaningful application

Understand time and space complexity trade-offs

Implement efficient algorithms for sorting and searching

Demonstrate how backend logic can be reused with different interfaces

DSA Concepts Used
Singly Linked List

Purpose:
Used to store the transaction history dynamically.

Why Linked List?

Transactions grow dynamically

Efficient insertion without resizing

Ideal for sequential data like logs

Operations Implemented:

Insert transaction → O(1)

Traverse history → O(n)

Remove last transaction → O(n)

File: linked_list.cpp

Stack (Undo Feature)

Purpose:
Implements the Undo Last Transaction functionality using the LIFO principle.

Each transaction pushed onto the stack can be reverted instantly.

Operations:

Push → O(1)

Pop → O(1)

This clearly demonstrates how stacks are used in real systems like:

Undo/Redo

Backtracking

Expression evaluation

 File: stack.cpp

3Dynamic Array (Binary Search Support)

Since binary search requires random access, the linked list is temporarily converted into a dynamic array.

Why?

Linked lists don’t support efficient indexing

Arrays allow O(1) access per index

Implemented in: linked_list.cpp (toArray())

Algorithms Implemented
Merge Sort (O(n log n))

Merge Sort is used to sort transactions:

By date

By amount

Why Merge Sort?

Guaranteed O(n log n) time

Works efficiently with linked lists

Stable sorting algorithm

Implementation Details:

List is split using slow-fast pointer method

Sublists are merged using comparison functions

File: linked_list.cpp

Binary Search (O(log n))

Binary Search is used to find a transaction by its ID.

Key Points:

Transaction IDs are inserted sequentially

After converting to array, binary search is applied

Reduces search time drastically compared to linear search

File: bank_ledger.cpp

System Design (Backend Focus)
BankLedger (Main Controller)
│
├── LinkedList (Transaction History)
│
├── Stack (Undo Transactions)
│
└── Algorithms
    ├── Merge Sort
    └── Binary Search


The backend is fully independent, meaning:

It works as a console application

It can be reused with any frontend

Project Structure
BankLedger/
├── include/
│   ├── transaction.h
│   ├── linked_list.h
│   ├── stack.h
│   └── bank_ledger.h
│
├── src/
│   ├── transaction.cpp
│   ├── linked_list.cpp
│   ├── stack.cpp
│   ├── bank_ledger.cpp
│   └── ffi_bridge.cpp
│
├── main.cpp
├── CMakeLists.txt
└── README.md

Frontend (Brief Overview)

A simple Flutter frontend is connected using FFI (Foreign Function Interface).

The frontend only calls backend functions

All logic, sorting, searching, and undo are handled in C++

Flutter is used purely for UI visualization

This separation ensures that DSA logic remains the main focus.

Time Complexity Summary
Operation	        Data Structure / Algorithm	Complexity
Insert Transaction	Linked List	                O(1)
Display History	    Traversal	                O(n)
Undo Transaction	Stack	                    O(1)
Sort Transactions	Merge Sort	                O(n log n)
Search by ID	    Binary Search	            O(log n)

Testing Highlights

Multiple deposits and withdrawals tested

Undo restores both balance and history correctly

Sorting verified for both date and amount

Binary search tested for existing and non-existing IDs

Build Instructions (CMake)
mkdir build
cd build
cmake ..
cmake --build .


Run console version:

bank_ledger_test.exe

Academic Relevance

This project fulfills all DSA course requirements:

--> Linked List implementation
--> Stack-based undo mechanism
--> Merge Sort (O(n log n))
--> Binary Search (O(log n))
--> Proper complexity analysis
--> Modular and well-documented code

Author

DSA Course Project – Phase 2
C++ Implementation of Core Data Structures and Algorithms

Final Note

This project demonstrates how abstract DSA concepts translate into real systems like banking software, showing both correctness and efficiency.