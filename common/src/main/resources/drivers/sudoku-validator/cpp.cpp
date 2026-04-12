#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse 2D JSON string array into vector<vector<char>>
    // Input: [["5","3",".",".","7",".",".",".","."],...]
    vector<vector<char>> board(9, vector<char>(9));
    int row = 0, col = 0, depth = 0;
    for (size_t i = 0; i < line.size(); i++) {
        char c = line[i];
        if (c == '[') {
            depth++;
        } else if (c == ']') {
            if (depth == 2) {
                row++;
                col = 0;
            }
            depth--;
        } else if (c == '"') {
            i++;
            board[row][col] = line[i];
            col++;
            i++; // skip closing quote
        }
    }
    bool result = Solution().isValidSudoku(board);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
