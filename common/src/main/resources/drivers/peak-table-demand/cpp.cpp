#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);

    vector<vector<int>> intervals;
    string inner = line.substr(1, line.size() - 2);
    int depth = 0, start = 0;
    for (int i = 0; i < (int)inner.size(); i++) {
        if (inner[i] == '[') { depth++; start = i; }
        else if (inner[i] == ']') {
            depth--;
            if (depth == 0) {
                string p = inner.substr(start + 1, i - start - 1);
                stringstream ss(p);
                string a, b;
                getline(ss, a, ',');
                getline(ss, b, ',');
                intervals.push_back({stoi(a), stoi(b)});
            }
        }
    }

    int result = Solution().findPeakGates(intervals);
    cout << result << endl;
    return 0;
}
