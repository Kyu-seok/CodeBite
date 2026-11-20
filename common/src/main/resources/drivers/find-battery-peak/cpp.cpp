#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

static bool isReturnedPeak(const vector<int>& readings, int i) {
    int n = readings.size();
    if (i < 0 || i >= n) return false;
    return (i == 0 || readings[i] > readings[i - 1]) && (i == n - 1 || readings[i] > readings[i + 1]);
}

int main() {
    string numsLine;
    getline(cin, numsLine);
    string inner = numsLine.substr(1, numsLine.size() - 2);
    vector<int> nums;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        nums.push_back(stoi(token));
    }
    vector<int> given = nums;
    int result = Solution().pinpointPeak(given);
    if (isReturnedPeak(nums, result)) {
        cout << "VALID" << endl;
    } else {
        cout << "INVALID:" << result << endl;
    }
    return 0;
}
