#include <iostream>
#include <string>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string boardLine, word;
    getline(cin, boardLine);
    getline(cin, word);

    vector<vector<char>> board;
    vector<char> row;
    bool inStr = false;
    for (char c : boardLine) {
        if (c == '"') { inStr = !inStr; continue; }
        if (inStr) { row.push_back(c); }
        if (c == ']' && !row.empty()) {
            board.push_back(row);
            row.clear();
        }
    }

    bool result = Solution().exist(board, word);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
