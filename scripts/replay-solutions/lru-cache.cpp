#include <list>
#include <unordered_map>
#include <utility>
using namespace std;

class LRUCache {
    int capacity;
    list<pair<int, int>> order;
    unordered_map<int, list<pair<int, int>>::iterator> where;
public:
    LRUCache(int capacity) : capacity(capacity) {}

    int get(int key) {
        auto it = where.find(key);
        if (it == where.end()) return -1;
        order.splice(order.end(), order, it->second);
        return it->second->second;
    }

    void put(int key, int value) {
        auto it = where.find(key);
        if (it != where.end()) {
            it->second->second = value;
            order.splice(order.end(), order, it->second);
            return;
        }
        order.push_back({key, value});
        where[key] = prev(order.end());
        if ((int)order.size() > capacity) {
            where.erase(order.front().first);
            order.pop_front();
        }
    }
};
