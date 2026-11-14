#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int trap(vector<int>& height) {
        int left = 0, right = (int)height.size() - 1, leftMax = 0, rightMax = 0, water = 0;
        while (left < right) {
            if (height[left] < height[right]) {
                leftMax = max(leftMax, height[left]);
                water += leftMax - height[left++];
            } else {
                rightMax = max(rightMax, height[right]);
                water += rightMax - height[right--];
            }
        }
        return water;
    }
};
