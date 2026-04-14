#include <iostream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string nStr, line;
    getline(cin, nStr);
    getline(cin, line);
    int n = stoi(nStr);

    vector<vector<int>> edges;
    if (line != "[]") {
        string inner = line.substr(1, line.size() - 2);
        int depth = 0;
        int start = 0;
        for (int i = 0; i < (int)inner.size(); i++) {
            if (inner[i] == '[') { depth++; start = i; }
            else if (inner[i] == ']') {
                depth--;
                if (depth == 0) {
                    string pairStr = inner.substr(start + 1, i - start - 1);
                    stringstream ss(pairStr);
                    string a, b;
                    getline(ss, a, ',');
                    getline(ss, b, ',');
                    edges.push_back({stoi(a), stoi(b)});
                }
            }
        }
    }

    int result = Solution().countComponents(n, edges);
    cout << result << endl;
    return 0;
}
