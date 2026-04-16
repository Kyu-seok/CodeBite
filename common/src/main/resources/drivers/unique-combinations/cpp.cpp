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
    int target;
    cin >> target;
    string inner = line.substr(1, line.size() - 2);
    vector<int> candidates;
    if (!inner.empty()) {
        stringstream ss(inner);
        string token;
        while (getline(ss, token, ',')) candidates.push_back(stoi(token));
    }
    vector<vector<int>> result = Solution().combinationSum2(candidates, target);
    for (auto& c : result) sort(c.begin(), c.end());
    sort(result.begin(), result.end());
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
