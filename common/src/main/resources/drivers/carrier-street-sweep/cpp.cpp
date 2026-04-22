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
    // Parse [["MUC","LHR"],["JFK","MUC"]]
    vector<vector<string>> tickets;
    int i = 1; // skip outer [
    while (i < (int)line.size() - 1) {
        if (line[i] == '[') {
            int j = line.find(']', i);
            string inner = line.substr(i + 1, j - i - 1);
            vector<string> pair;
            size_t pos = 0;
            while (pos < inner.size()) {
                if (inner[pos] == '"') {
                    size_t end = inner.find('"', pos + 1);
                    pair.push_back(inner.substr(pos + 1, end - pos - 1));
                    pos = end + 1;
                } else {
                    pos++;
                }
            }
            tickets.push_back(pair);
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<string> result = Solution().traceStreetSweep(tickets);
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
