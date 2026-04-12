#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    string line;
    getline(cin, line);
    // Parse ["code","bite"]
    vector<string> wordDict;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty()) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '"') {
                int j = inner.find('"', i + 1);
                wordDict.push_back(inner.substr(i + 1, j - i - 1));
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    bool result = Solution().wordBreak(s, wordDict);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
