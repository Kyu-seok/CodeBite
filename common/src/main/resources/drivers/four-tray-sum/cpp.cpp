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
    vector<int> trays;
    if (!inner.empty()) {
        stringstream ss(inner);
        string token;
        while (getline(ss, token, ',')) trays.push_back(stoi(token));
    }
    string demandLine;
    getline(cin, demandLine);
    int demand = stoi(demandLine);
    vector<vector<int>> result = Solution().fourTraySum(trays, demand);
    for (auto& q : result) sort(q.begin(), q.end());
    sort(result.begin(), result.end());
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
