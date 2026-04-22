#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <queue>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[0,2],[1,3]]
    vector<vector<int>> grid;
    int i = 0;
    while (i < (int)line.size()) {
        if (line[i] == '[' && i > 0) {
            int j = line.find(']', i);
            string sub = line.substr(i + 1, j - i - 1);
            vector<int> row;
            stringstream ss(sub);
            string token;
            while (getline(ss, token, ',')) {
                row.push_back(stoi(token));
            }
            grid.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    cout << Solution().crossFloodedCorridors(grid) << endl;
    return 0;
}
