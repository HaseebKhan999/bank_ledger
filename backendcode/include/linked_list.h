#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include "transaction.h"
#include <iostream>

class Node {
public:
    Transaction* data;
    Node* next;

    Node(Transaction* t) : data(t), next(nullptr) {}
};

class LinkedList {
private:
    Node* head;
    Node* tail;
    int count;

    // Merge sort helpers
    Node* merge(Node* left, Node* right, bool (*compare)(Transaction*, Transaction*));
    Node* mergeSort(Node* h, bool (*compare)(Transaction*, Transaction*));
    Node* getMiddle(Node* h);

public:
    LinkedList();
    ~LinkedList();

    // Insert at end
    void insert(Transaction* t);

    // Remove last node, return Transaction* without deleting it
    Transaction* removeLast();

    // Display list
    void display();

    // Size
    int size() const { return count; }

    // Check if empty
    bool isEmpty() const { return head == nullptr; }

    // Sorting
    void sortByDate();
    void sortByAmount();

    // Convert to array
    Transaction** toArray();

    // Get item at index
    Transaction* getAt(int index);

    // Update tail after sorting
    void updateTail();

    Node* getHead() { return head; }
    void setHead(Node* h) { head = h; }
};

#endif
