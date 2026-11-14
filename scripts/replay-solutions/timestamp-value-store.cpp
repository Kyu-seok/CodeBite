#include <string>
#include <map>
#include <unordered_map>
using namespace std;

class TimestampedStore {
    unordered_map<string, map<int, string>> history;
public:
    TimestampedStore() {}

    void write(string key, string value, int timestamp) {
        history[key][timestamp] = value;
    }

    string readAt(string key, int timestamp) {
        auto it = history.find(key);
        if (it == history.end()) return "";
        auto w = it->second.upper_bound(timestamp);
        if (w == it->second.begin()) return "";
        return prev(w)->second;
    }
};
