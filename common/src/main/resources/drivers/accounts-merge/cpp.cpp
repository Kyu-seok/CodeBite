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
    // Parse [["John","a@b.com"],["Mary","c@d.com"]]
    vector<vector<string>> accounts;
    int i = 1; // skip outer [
    while (i < (int)line.size() - 1) {
        if (line[i] == '[') {
            int j = line.find(']', i);
            string inner = line.substr(i + 1, j - i - 1);
            vector<string> account;
            size_t pos = 0;
            while (pos < inner.size()) {
                if (inner[pos] == '"') {
                    size_t end = inner.find('"', pos + 1);
                    account.push_back(inner.substr(pos + 1, end - pos - 1));
                    pos = end + 1;
                } else {
                    pos++;
                }
            }
            accounts.push_back(account);
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<vector<string>> result = Solution().accountsMerge(accounts);
    // Sort emails within each account, then sort by first email
    for (auto& account : result) {
        sort(account.begin() + 1, account.end());
    }
    sort(result.begin(), result.end(), [](const vector<string>& a, const vector<string>& b) {
        return a[1] < b[1];
    });
    cout << JsonOutput::stringVector2D(result) << endl;
    return 0;
}
