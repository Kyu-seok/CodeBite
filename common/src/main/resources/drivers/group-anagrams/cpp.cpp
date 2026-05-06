#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
#include <unordered_map>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse ["eat","tea","tan"]
    vector<string> strs;
    size_t pos = 0;
    while (pos < line.size()) {
        if (line[pos] == '"') {
            size_t end = line.find('"', pos + 1);
            strs.push_back(line.substr(pos + 1, end - pos - 1));
            pos = end + 1;
        } else {
            pos++;
        }
    }
    vector<vector<string>> result = Solution().groupAnagrams(strs);
    for (auto& g : result) sort(g.begin(), g.end());
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector2D(result) << endl;
    return 0;
}
