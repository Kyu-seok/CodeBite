#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);

    vector<vector<int>> heights;
    string inner = line.substr(1, line.size() - 2);
    int depth = 0;
    int start = 0;
    for (int i = 0; i < (int)inner.size(); i++) {
        if (inner[i] == '[') { depth++; start = i; }
        else if (inner[i] == ']') {
            depth--;
            if (depth == 0) {
                string rowStr = inner.substr(start + 1, i - start - 1);
                vector<int> row;
                stringstream ss(rowStr);
                string token;
                while (getline(ss, token, ',')) row.push_back(stoi(token));
                heights.push_back(row);
            }
        }
    }

    vector<vector<int>> result = Solution().traceDualDrainage(heights);
    sort(result.begin(), result.end());
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << "[" << result[i][0] << "," << result[i][1] << "]";
    }
    cout << "]" << endl;
    return 0;
}
