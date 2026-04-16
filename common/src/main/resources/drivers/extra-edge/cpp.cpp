#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[1,2],[1,3],[2,3]]
    vector<vector<int>> edges;
    int i = 0;
    while (i < (int)line.size()) {
        if (line[i] == '[' && i > 0) {
            int j = line.find(']', i);
            string sub = line.substr(i + 1, j - i - 1);
            vector<int> edge;
            stringstream ss(sub);
            string token;
            while (getline(ss, token, ',')) {
                edge.push_back(stoi(token));
            }
            edges.push_back(edge);
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<int> result = Solution().findExtraEdge(edges);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
