#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

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
    string kLine;
    getline(cin, kLine);
    int k = stoi(kLine);
    int result = Solution().findBrightestTargets(nums, k);
    cout << result << endl;
    return 0;
}
