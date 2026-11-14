#include <vector>
#include <queue>
#include <functional>
using namespace std;

class Solution {
public:
    int minutesToReachAll(vector<vector<int>>& links, int n, int src) {
        vector<vector<pair<int, int>>> graph(n + 1);
        for (const vector<int>& link : links) graph[link[0]].push_back(make_pair(link[1], link[2]));
        vector<int> arrival(n + 1, -1);
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> heap;
        heap.push(make_pair(0, src));
        int reached = 0, latest = 0;
        while (!heap.empty()) {
            pair<int, int> top = heap.top();
            heap.pop();
            if (arrival[top.second] != -1) continue;
            arrival[top.second] = top.first;
            reached++;
            latest = top.first;
            for (const pair<int, int>& edge : graph[top.second]) {
                if (arrival[edge.first] == -1) heap.push(make_pair(top.first + edge.second, edge.first));
            }
        }
        return reached == n ? latest : -1;
    }
};
