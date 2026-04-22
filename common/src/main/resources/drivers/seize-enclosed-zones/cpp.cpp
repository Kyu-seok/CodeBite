#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [["X","O"],["O","X"]]
    vector<vector<char>> board;
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
            board.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    Solution().seizeEnclosedZones(board);
    // Output as 2D string array
    cout << "[";
    for (int r = 0; r < (int)board.size(); r++) {
        if (r > 0) cout << ",";
        cout << "[";
        for (int c = 0; c < (int)board[r].size(); c++) {
            if (c > 0) cout << ",";
            cout << "\"" << board[r][c] << "\"";
        }
        cout << "]";
    }
    cout << "]" << endl;
    return 0;
}
