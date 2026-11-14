#include <vector>
#include <deque>
using namespace std;

class Solution {
public:
    vector<int> peakComboPerWindow(vector<int>& combo, int k) {
        deque<int> window;
        vector<int> peaks;
        for (int i = 0; i < (int)combo.size(); i++) {
            while (!window.empty() && combo[window.back()] <= combo[i]) window.pop_back();
            window.push_back(i);
            if (window.front() <= i - k) window.pop_front();
            if (i >= k - 1) peaks.push_back(combo[window.front()]);
        }
        return peaks;
    }
};
