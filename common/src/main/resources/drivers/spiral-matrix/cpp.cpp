#include <iostream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);

    vector<vector<int>> matrix;
    string inner = line.substr(1, line.size() - 2);
    int depth = 0, start = 0;
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
                matrix.push_back(row);
            }
        }
    }

    vector<int> result = Solution().spiralOrder(matrix);
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << result[i];
    }
    cout << "]" << endl;
    return 0;
}
