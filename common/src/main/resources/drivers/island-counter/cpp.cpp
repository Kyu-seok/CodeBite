#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [["1","0"],["0","1"]]
    vector<vector<char>> grid;
    int i = 1; // skip outer [
    while (i < (int)line.size() - 1) {
        if (line[i] == '[') {
            int j = line.find(']', i);
            string rowStr = line.substr(i + 1, j - i - 1);
            vector<char> row;
            for (int k = 0; k < (int)rowStr.size(); k++) {
                if (rowStr[k] == '"') {
                    row.push_back(rowStr[k + 1]);
                    k += 2; // skip char and closing quote
                }
            }
            grid.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    cout << Solution().numIslands(grid) << endl;
    return 0;
}
