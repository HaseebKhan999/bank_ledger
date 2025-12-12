#include "../include/stack.h"

Stack::Stack(int max) {
    top = nullptr;
    count = 0;
    maxSize = max;
}

Stack::~Stack() {
    while (top != nullptr) {
        StackNode* temp = top;
        top = top->next;

        delete temp->data;   // free transaction
        delete temp;         // free node
    }
}

bool Stack::push(Transaction* t) {
    if (isFull()) {
        return false;
    }

    StackNode* newNode = new StackNode(t);
    newNode->next = top;
    top = newNode;
    count++;

    return true;
}

Transaction* Stack::pop() {
    if (isEmpty()) {
        return nullptr;
    }

    StackNode* temp = top;
    Transaction* t = temp->data;

    top = top->next;
    delete temp;     // delete only node, NOT transaction (you return it)
    count--;

    return t;        // caller will delete t when needed
}
