#include <vector>
#include <utility>
using namespace std;

class ChainedMap {
    static const int BUCKETS = 2069;
    vector<vector<pair<int, int>>> buckets;

public:
    ChainedMap() : buckets(BUCKETS) {
    }

    void set(int key, int value) {
        vector<pair<int, int>>& bucket = buckets[key % BUCKETS];
        for (size_t i = 0; i < bucket.size(); i++) {
            if (bucket[i].first == key) {
                bucket[i].second = value;
                return;
            }
        }
        bucket.push_back(make_pair(key, value));
    }

    int lookup(int key) {
        vector<pair<int, int>>& bucket = buckets[key % BUCKETS];
        for (size_t i = 0; i < bucket.size(); i++) {
            if (bucket[i].first == key) return bucket[i].second;
        }
        return -1;
    }

    void erase(int key) {
        vector<pair<int, int>>& bucket = buckets[key % BUCKETS];
        for (size_t i = 0; i < bucket.size(); i++) {
            if (bucket[i].first == key) {
                bucket.erase(bucket.begin() + i);
                return;
            }
        }
    }
};
