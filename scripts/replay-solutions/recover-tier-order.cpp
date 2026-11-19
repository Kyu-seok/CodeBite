#include <vector>
#include <string>
#include <set>
#include <map>
#include <queue>
#include <functional>
using namespace std;

class Solution {
public:
    string recoverTierOrder(vector<string>& tags) {
        set<char> letters;
        for (auto& tag : tags) for (char ch : tag) letters.insert(ch);
        map<char, set<char>> after;
        map<char, int> indegree;
        for (char ch : letters) { after[ch]; indegree[ch] = 0; }
        for (size_t i = 0; i + 1 < tags.size(); i++) {
            const string& first = tags[i];
            const string& second = tags[i + 1];
            size_t len = min(first.size(), second.size()), j = 0;
            while (j < len && first[j] == second[j]) j++;
            if (j == len) {
                if (first.size() > second.size()) return "";
            } else if (after[first[j]].insert(second[j]).second) {
                indegree[second[j]]++;
            }
        }
        priority_queue<char, vector<char>, greater<char>> ready;
        for (char ch : letters) if (indegree[ch] == 0) ready.push(ch);
        string order;
        while (!ready.empty()) {
            char ch = ready.top();
            ready.pop();
            order += ch;
            for (char next : after[ch]) if (--indegree[next] == 0) ready.push(next);
        }
        return order.size() == letters.size() ? order : "";
    }
};
