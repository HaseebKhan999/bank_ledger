#include "../include/linked_list.h"
#include <iostream>

LinkedList::LinkedList() {
    head = nullptr;
    tail = nullptr;
    count = 0;
}

LinkedList::~LinkedList() {
    Node* current = head;
    while (current != nullptr) {
        Node* temp = current;
        current = current->next;
        delete temp->data;   // Delete Transaction
        delete temp;         // Delete Node
    }
}

void LinkedList::insert(Transaction* t) {
    Node* newNode = new Node(t);

    if (head == nullptr) {
        head = tail = newNode;
    } else {
        tail->next = newNode;
        tail = newNode;
    }

    count++;
}

Transaction* LinkedList::removeLast() {
    if (head == nullptr) {
        return nullptr;
    }

    Transaction* t = tail->data;   // Return the transaction without deleting it

    if (head == tail) {
        delete head;
        head = tail = nullptr;
    } else {
        Node* current = head;
        while (current->next != tail) {
            current = current->next;
        }

        delete tail;       // Delete node ONLY
        tail = current;    // Update tail
        tail->next = nullptr;
    }

    count--;
    return t;
}

void LinkedList::display() {
    if (head == nullptr) {
        std::cout << "No transactions found.\n";
        return;
    }

    std::cout << "\n=== Transaction History ===\n";
    std::cout << "Total Transactions: " << count << "\n";
    std::cout << "----------------------------\n";

    Node* current = head;
    int num = 1;

    while (current != nullptr) {
        std::cout << num++ << ". ";
        current->data->display();
        current = current->next;
    }
}

// ===== Merge Sort Helpers =====

Node* LinkedList::getMiddle(Node* h) {
    if (h == nullptr) return h;

    Node* slow = h;
    Node* fast = h->next;

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    return slow;
}

Node* LinkedList::merge(Node* left, Node* right, bool (*compare)(Transaction*, Transaction*)) {
    if (left == nullptr) return right;
    if (right == nullptr) return left;

    Node* result = nullptr;

    if (compare(left->data, right->data)) {
        result = left;
        result->next = merge(left->next, right, compare);
    } else {
        result = right;
        result->next = merge(left, right->next, compare);
    }

    return result;
}

Node* LinkedList::mergeSort(Node* h, bool (*compare)(Transaction*, Transaction*)) {
    if (h == nullptr || h->next == nullptr)
        return h;

    Node* middle = getMiddle(h);
    Node* nextOfMiddle = middle->next;
    middle->next = nullptr;

    Node* left = mergeSort(h, compare);
    Node* right = mergeSort(nextOfMiddle, compare);

    return merge(left, right, compare);
}

// ===== Sorting Functions =====

static bool compareByDate(Transaction* t1, Transaction* t2) {
    return t1->timestamp <= t2->timestamp;
}

static bool compareByAmount(Transaction* t1, Transaction* t2) {
    return t1->amount <= t2->amount;
}

void LinkedList::sortByDate() {
    if (head == nullptr || head->next == nullptr) return;

    head = mergeSort(head, compareByDate);
    updateTail();

    std::cout << "Transactions sorted by date.\n";
}

void LinkedList::sortByAmount() {
    if (head == nullptr || head->next == nullptr) return;

    head = mergeSort(head, compareByAmount);
    updateTail();

    std::cout << "Transactions sorted by amount.\n";
}

// ===== Array Conversion =====

Transaction** LinkedList::toArray() {
    if (count == 0) return nullptr;

    Transaction** arr = new Transaction*[count];
    Node* current = head;
    int i = 0;

    while (current != nullptr) {
        arr[i++] = current->data;
        current = current->next;
    }

    return arr;
}

Transaction* LinkedList::getAt(int index) {
    if (index < 0 || index >= count) return nullptr;

    Node* current = head;
    for (int i = 0; i < index; i++) {
        current = current->next;
    }

    return current->data;
}

void LinkedList::updateTail() {
    if (head == nullptr) {
        tail = nullptr;
        return;
    }

    Node* current = head;
    while (current->next != nullptr) {
        current = current->next;
    }

    tail = current;
}
