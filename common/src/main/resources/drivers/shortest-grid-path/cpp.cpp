#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[0,1],[1,0]]
    vector<vector<int>> grid;
    int i = 0;
    while (i < (int)line.size()) {
        if (line[i] == '[' && i > 0) {
            int j = line.find(']', i);
            string sub = line.substr(i + 1, j - i - 1);
            vector<int> row;
            if (!sub.empty()) {
                stringstream ss(sub);
                string token;
                while (getline(ss, token, ',')) {
                    row.push_back(stoi(token));
                }
            }
            grid.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    cout << Solution().shortestPath(grid) << endl;
    return 0;
}
