#include <iostream>
#include <vector>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <queue>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse ["wrt","wrf","er","ett","rftt"]
    vector<string> words;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty()) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '"') {
                int j = inner.find('"', i + 1);
                words.push_back(inner.substr(i + 1, j - i - 1));
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    string result = Solution().orderSceneShoot(words);
    cout << result << endl;
    return 0;
}
