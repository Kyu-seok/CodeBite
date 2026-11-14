#include <vector>
using namespace std;

class Solution {
public:
    vector<int> findMenuPair(vector<int>& menuPrice, int budget) {
        int left = 0, right = (int) menuPrice.size() - 1;
        while (left < right) {
            int total = menuPrice[left] + menuPrice[right];
            if (total == budget) return {left + 1, right + 1};
            if (total < budget) left++;
            else right--;
        }
        return {};
    }
};
