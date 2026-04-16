#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string intervalsLine, queriesLine;
    getline(cin, intervalsLine);
    getline(cin, queriesLine);
    // Parse intervals [[1,4],[2,4],[3,6],[2,8]]
    vector<vector<int>> intervals;
    int i = 0;
    while (i < (int)intervalsLine.size()) {
        if (intervalsLine[i] == '[' && i > 0) {
            int j = intervalsLine.find(']', i);
            string sub = intervalsLine.substr(i + 1, j - i - 1);
            stringstream ss(sub);
            string token;
            vector<int> pair;
            while (getline(ss, token, ',')) {
                pair.push_back(stoi(token));
            }
            intervals.push_back(pair);
            i = j + 1;
        } else {
            i++;
        }
    }
    // Parse queries [2,3,4,5]
    string inner = queriesLine.substr(1, queriesLine.size() - 2);
    vector<int> queries;
    stringstream qs(inner);
    string tok;
    while (getline(qs, tok, ',')) {
        queries.push_back(stoi(tok));
    }
    vector<int> result = Solution().minInterval(intervals, queries);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
