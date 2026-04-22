#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <deque>
using namespace std;

// {{LIB:JsonOutput}}

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
    int k;
    cin >> k;
    vector<int> result = Solution().peakFlowPerStretch(nums, k);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
