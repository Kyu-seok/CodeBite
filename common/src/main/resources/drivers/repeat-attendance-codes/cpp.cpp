#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string codesLine;
    getline(cin, codesLine);
    string inner = codesLine.substr(1, codesLine.size() - 2);
    vector<int> codes;
    if (!inner.empty()) {
        stringstream ss(inner);
        string token;
        while (getline(ss, token, ',')) {
            codes.push_back(stoi(token));
        }
    }
    vector<int> result = Solution().listRepeatedCodes(codes);
    sort(result.begin(), result.end());
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << result[i];
    }
    cout << "]" << endl;
    return 0;
}
