#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[1,3],[2,6],[8,10],[15,18]]
    vector<vector<int>> intervals;
    int i = 0;
    while (i < (int)line.size()) {
        if (line[i] == '[' && i > 0) {
            int j = line.find(']', i);
            string inner = line.substr(i + 1, j - i - 1);
            stringstream ss(inner);
            string token;
            vector<int> interval;
            while (getline(ss, token, ',')) interval.push_back(stoi(token));
            intervals.push_back(interval);
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<vector<int>> result = Solution().merge(intervals);
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
