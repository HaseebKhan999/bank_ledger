#ifndef STACK_H
#define STACK_H

#include "transaction.h"

class StackNode {
public:
    Transaction* data;
    StackNode* next;

    StackNode(Transaction* t) {
        data = t;
        next = nullptr;
    }
};

class Stack {
private:
    StackNode* top;
    int count;
    int maxSize;

public:
    Stack(int max = 50);
    ~Stack();

    bool push(Transaction* t);
    Transaction* pop();

    bool isEmpty() const {
        return top == nullptr;
    }

    bool isFull() const {
        return count >= maxSize;
    }

    int size() const {
        return count;
    }
};

#endif
