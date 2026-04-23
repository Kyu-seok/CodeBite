#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string beginWord, endWord, line;
    getline(cin, beginWord);
    getline(cin, endWord);
    getline(cin, line);
    // Parse JSON string array ["hot","dot","dog"]
    vector<string> wordList;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty()) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '"') {
                int j = inner.find('"', i + 1);
                wordList.push_back(inner.substr(i + 1, j - i - 1));
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    int result = Solution().bridgeLabelChain(beginWord, endWord, wordList);
    cout << result << endl;
    return 0;
}
