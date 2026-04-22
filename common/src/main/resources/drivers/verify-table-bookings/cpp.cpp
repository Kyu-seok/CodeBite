#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[0,30],[5,10],[15,20]]
    vector<vector<int>> intervals;
    int depth = 0;
    for (int i = 0; i < (int)line.size(); i++) {
        char c = line[i];
        if (c == '[') {
            depth++;
            if (depth == 2) {
                int j = line.find(']', i);
                string sub = line.substr(i + 1, j - i - 1);
                if (!sub.empty()) {
                    vector<int> pair;
                    stringstream ss(sub);
                    string token;
                    while (getline(ss, token, ',')) {
                        pair.push_back(stoi(token));
                    }
                    intervals.push_back(pair);
                }
                i = j;
                depth--;
            }
        } else if (c == ']') {
            depth--;
        }
    }
    bool result = Solution().verifyTableBookings(intervals);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
