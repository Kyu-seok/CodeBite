#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string inner = line.substr(1, line.size() - 2);
    vector<int> nums;
    if (!inner.empty()) {
        stringstream ss(inner);
        string token;
        while (getline(ss, token, ',')) nums.push_back(stoi(token));
    }
    string targetLine;
    getline(cin, targetLine);
    int target = stoi(targetLine);
    vector<vector<int>> result = Solution().quadTrayDemand(nums, target);
    for (auto& q : result) sort(q.begin(), q.end());
    sort(result.begin(), result.end());
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
