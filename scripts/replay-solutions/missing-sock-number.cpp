#include <vector>
#include <utility>
using namespace std;

class Solution {
public:
    int smallestMissingNumber(vector<int>& socks) {
        int n = socks.size();
        for (int i = 0; i < n; i++) {
            while (socks[i] >= 1 && socks[i] <= n && socks[socks[i] - 1] != socks[i]) {
                swap(socks[i], socks[socks[i] - 1]);
            }
        }
        for (int i = 0; i < n; i++) {
            if (socks[i] != i + 1) return i + 1;
        }
        return n + 1;
    }
};
