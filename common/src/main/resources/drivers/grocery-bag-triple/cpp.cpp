#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

vector<int> parseArray(const string& s) {
    vector<int> res;
    string inner = s.substr(1, s.size() - 2);
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        res.push_back(stoi(token));
    }
    return res;
}

int main() {
    string tripletsLine, targetLine;
    getline(cin, tripletsLine);
    getline(cin, targetLine);
    // Parse 2D array
    vector<vector<int>> triplets;
    int i = 0;
    while (i < (int)tripletsLine.size()) {
        if (tripletsLine[i] == '[' && i > 0) {
            int j = tripletsLine.find(']', i);
            string sub = tripletsLine.substr(i, j - i + 1);
            triplets.push_back(parseArray(sub));
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<int> target = parseArray(targetLine);
    bool result = Solution().canBuildBales(triplets, target);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
