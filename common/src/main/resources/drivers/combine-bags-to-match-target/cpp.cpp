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
    string bagsLine, targetLine;
    getline(cin, bagsLine);
    getline(cin, targetLine);
    // Parse 2D array
    vector<vector<int>> bags;
    int i = 0;
    while (i < (int)bagsLine.size()) {
        if (bagsLine[i] == '[' && i > 0) {
            int j = bagsLine.find(']', i);
            string sub = bagsLine.substr(i, j - i + 1);
            bags.push_back(parseArray(sub));
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<int> target = parseArray(targetLine);
    bool result = Solution().canMatchTarget(bags, target);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
