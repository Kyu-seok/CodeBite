#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string line, kStr;
    getline(cin, line);
    getline(cin, kStr);
    int k = stoi(kStr);

    vector<vector<int>> points;
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
                points.push_back({stoi(a), stoi(b)});
            }
        }
    }

    vector<vector<int>> result = Solution().selectNearestStops(points, k);
    sort(result.begin(), result.end());
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << "[" << result[i][0] << "," << result[i][1] << "]";
    }
    cout << "]" << endl;
    return 0;
}
