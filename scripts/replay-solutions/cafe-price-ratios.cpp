#include <vector>
#include <string>
#include <map>
#include <utility>
using namespace std;

class Solution {
public:
    vector<double> resolvePriceRatios(vector<vector<string>>& ratios, vector<double>& values, vector<vector<string>>& queries) {
        map<string, vector<pair<string, double>>> graph;
        for (size_t i = 0; i < ratios.size(); i++) {
            graph[ratios[i][0]].push_back(make_pair(ratios[i][1], values[i]));
            graph[ratios[i][1]].push_back(make_pair(ratios[i][0], 1.0 / values[i]));
        }
        vector<double> out;
        for (auto& q : queries) {
            double answer = -1.0;
            if (graph.count(q[0]) && graph.count(q[1])) {
                map<string, double> seen;
                vector<string> stack;
                seen[q[0]] = 1.0;
                stack.push_back(q[0]);
                while (!stack.empty()) {
                    string item = stack.back();
                    stack.pop_back();
                    if (item == q[1]) { answer = seen[item]; break; }
                    for (auto& edge : graph[item]) {
                        if (!seen.count(edge.first)) {
                            seen[edge.first] = seen[item] * edge.second;
                            stack.push_back(edge.first);
                        }
                    }
                }
            }
            out.push_back(answer);
        }
        return out;
    }
};
