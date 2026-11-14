#include <vector>
#include <map>
using namespace std;

class VersionedCells {
    vector<map<int, int>> history;
    int snapId = 0;

public:
    VersionedCells(int length) : history(length) {
        for (map<int, int>& cell : history) cell[-1] = 0;
    }

    void set(int index, int val) {
        history[index][snapId] = val;
    }

    int commit() {
        return snapId++;
    }

    int readAt(int index, int snapId) {
        map<int, int>& cell = history[index];
        map<int, int>::iterator it = cell.upper_bound(snapId);
        --it;
        return it->second;
    }
};
