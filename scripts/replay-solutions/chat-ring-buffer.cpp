#include <vector>
using namespace std;

class FixedRing {
    vector<int> slots;
    int head = 0;
    int size = 0;

public:
    FixedRing(int k) : slots(k) {}

    bool push(int value) {
        if (isFull()) return false;
        slots[(head + size) % slots.size()] = value;
        size++;
        return true;
    }

    bool pull() {
        if (isEmpty()) return false;
        head = (head + 1) % slots.size();
        size--;
        return true;
    }

    int front() {
        return isEmpty() ? -1 : slots[head];
    }

    int rear() {
        return isEmpty() ? -1 : slots[(head + size - 1) % slots.size()];
    }

    bool isEmpty() {
        return size == 0;
    }

    bool isFull() {
        return size == (int) slots.size();
    }
};
