#include <iostream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string intLine, newLine;
    getline(cin, intLine);
    getline(cin, newLine);

    vector<vector<int>> intervals;
    if (intLine != "[]") {
        string inner = intLine.substr(1, intLine.size() - 2);
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
    }

    string ni = newLine.substr(1, newLine.size() - 2);
    stringstream ss(ni);
    string a, b;
    getline(ss, a, ',');
    getline(ss, b, ',');
    vector<int> newInterval = {stoi(a), stoi(b)};

    vector<vector<int>> result = Solution().scheduleObservingWindow(intervals, newInterval);
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << "[" << result[i][0] << "," << result[i][1] << "]";
    }
    cout << "]" << endl;
    return 0;
}
