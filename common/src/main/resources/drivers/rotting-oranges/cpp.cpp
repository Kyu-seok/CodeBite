#include <iostream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);

    vector<vector<int>> grid;
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
                grid.push_back(row);
            }
        }
    }

    int result = Solution().orangesRotting(grid);
    cout << result << endl;
    return 0;
}
