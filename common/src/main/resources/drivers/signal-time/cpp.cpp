#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse 2D int array [[2,1,1],[2,3,1],[3,4,1]]
    vector<vector<int>> edges;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty() && inner.find('[') != string::npos) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '[') {
                int j = inner.find(']', i);
                string tripleStr = inner.substr(i + 1, j - i - 1);
                vector<int> triple;
                stringstream ss(tripleStr);
                string token;
                while (getline(ss, token, ',')) {
                    triple.push_back(stoi(token));
                }
                edges.push_back(triple);
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    int n, src;
    cin >> n >> src;
    int result = Solution().signalTime(edges, n, src);
    cout << result << endl;
    return 0;
}
