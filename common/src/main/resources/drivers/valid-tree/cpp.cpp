#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    int n;
    string line;
    getline(cin, line);
    n = stoi(line);
    getline(cin, line);
    // Parse 2D int array [[0,1],[0,2]]
    vector<vector<int>> edges;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty() && inner.find('[') != string::npos) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '[') {
                int j = inner.find(']', i);
                string pairStr = inner.substr(i + 1, j - i - 1);
                vector<int> pair;
                stringstream ss(pairStr);
                string token;
                while (getline(ss, token, ',')) {
                    pair.push_back(stoi(token));
                }
                edges.push_back(pair);
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    bool result = Solution().validTree(n, edges);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
