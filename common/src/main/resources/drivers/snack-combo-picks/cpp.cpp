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
    vector<int> snacks;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) snacks.push_back(stoi(token));
    vector<vector<int>> result = Solution().listSnackCombos(snacks);
    for (auto& s : result) sort(s.begin(), s.end());
    sort(result.begin(), result.end());
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
