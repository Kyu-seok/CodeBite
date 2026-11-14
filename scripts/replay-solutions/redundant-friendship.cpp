#include <vector>
using namespace std;

class Solution {
    vector<int> parent;

    int find(int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }

public:
    vector<int> spotRedundantLink(vector<vector<int>>& links) {
        parent.assign(links.size() + 1, 0);
        for (size_t i = 0; i < parent.size(); i++) parent[i] = i;
        for (const vector<int>& link : links) {
            int rootA = find(link[0]), rootB = find(link[1]);
            if (rootA == rootB) return {link[0], link[1]};
            parent[rootA] = rootB;
        }
        return {};
    }
};
