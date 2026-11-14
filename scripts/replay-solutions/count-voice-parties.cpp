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
    int countParties(int n, vector<vector<int>>& relays) {
        parent.assign(n, 0);
        for (int i = 0; i < n; i++) parent[i] = i;
        int parties = n;
        for (const vector<int>& relay : relays) {
            int ra = find(relay[0]), rb = find(relay[1]);
            if (ra != rb) {
                parent[ra] = rb;
                parties--;
            }
        }
        return parties;
    }
};
