#include <string>
#include <vector>
using namespace std;

class Solution {
public:
    bool containsNameAnagram(string pattern, string log) {
        int size = pattern.size();
        if (size > (int)log.size()) return false;
        vector<int> diff(26, 0);
        for (int i = 0; i < size; i++) {
            diff[pattern[i] - 'a']++;
            diff[log[i] - 'a']--;
        }
        if (allZero(diff)) return true;
        for (int i = size; i < (int)log.size(); i++) {
            diff[log[i] - 'a']--;
            diff[log[i - size] - 'a']++;
            if (allZero(diff)) return true;
        }
        return false;
    }

private:
    bool allZero(const vector<int>& counts) {
        for (int c : counts) if (c != 0) return false;
        return true;
    }
};
