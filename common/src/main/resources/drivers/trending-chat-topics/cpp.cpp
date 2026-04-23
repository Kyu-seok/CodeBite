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
    // Parse ["apple","banana","apple"]
    vector<string> words;
    size_t pos = 0;
    while (pos < line.size()) {
        if (line[pos] == '"') {
            size_t end = line.find('"', pos + 1);
            words.push_back(line.substr(pos + 1, end - pos - 1));
            pos = end + 1;
        } else {
            pos++;
        }
    }
    int k;
    cin >> k;
    vector<string> result = Solution().rankTrendingTopics(words, k);
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
