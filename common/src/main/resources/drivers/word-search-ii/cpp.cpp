#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string boardLine, wordsLine;
    getline(cin, boardLine);
    getline(cin, wordsLine);

    // Parse 2D board
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

    // Parse words
    vector<string> words;
    string word;
    inStr = false;
    for (char c : wordsLine) {
        if (c == '"') {
            if (inStr) { words.push_back(word); word = ""; }
            inStr = !inStr;
            continue;
        }
        if (inStr) word += c;
    }

    vector<string> result = Solution().findWords(board, words);
    sort(result.begin(), result.end());
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << "\"" << result[i] << "\"";
    }
    cout << "]" << endl;
    return 0;
}
