#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <unordered_set>
using namespace std;

{USER_CODE}

int main() {
    string numsLine;
    getline(cin, numsLine);
    string inner = numsLine.substr(1, numsLine.size() - 2);
    vector<int> nums;
    if (!inner.empty()) {
        stringstream ss(inner);
        string token;
        while (getline(ss, token, ',')) {
            nums.push_back(stoi(token));
        }
    }
    int result = Solution().longestSeatBlock(nums);
    cout << result << endl;
    return 0;
}
