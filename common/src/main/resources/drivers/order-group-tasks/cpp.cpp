#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

{USER_CODE}

static bool hasCycle(int n, const vector<vector<int>>& prereqs) {
    vector<vector<int>> adj(n);
    vector<int> indeg(n, 0);
    for (const auto& e : prereqs) {
        adj[e[1]].push_back(e[0]);
        indeg[e[0]]++;
    }
    queue<int> q;
    for (int i = 0; i < n; i++) if (indeg[i] == 0) q.push(i);
    int processed = 0;
    while (!q.empty()) {
        int u = q.front(); q.pop();
        processed++;
        for (int v : adj[u]) {
            if (--indeg[v] == 0) q.push(v);
        }
    }
    return processed != n;
}

static bool isValid(int n, const vector<vector<int>>& prereqs, const vector<int>& result) {
    if ((int)result.size() == 0) return hasCycle(n, prereqs);
    if ((int)result.size() != n) return false;
    vector<bool> seen(n, false);
    vector<int> pos(n, 0);
    for (int i = 0; i < (int)result.size(); i++) {
        int v = result[i];
        if (v < 0 || v >= n || seen[v]) return false;
        seen[v] = true;
        pos[v] = i;
    }
    for (const auto& e : prereqs) {
        if (pos[e[1]] >= pos[e[0]]) return false;
    }
    return true;
}

int main() {
    string nStr, line;
    getline(cin, nStr);
    getline(cin, line);
    int numCourses = stoi(nStr);

    vector<vector<int>> prerequisites;
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
                    prerequisites.push_back({stoi(a), stoi(b)});
                }
            }
        }
    }

    vector<int> result = Solution().sequenceAssemblySteps(numCourses, prerequisites);
    cout << (isValid(numCourses, prerequisites, result) ? "VALID" : "INVALID") << endl;
    return 0;
}
