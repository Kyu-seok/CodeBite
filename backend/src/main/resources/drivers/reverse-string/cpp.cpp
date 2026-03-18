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
    // Parse ["h","e","l","l","o"] -> vector<char>
    vector<char> s;
    for (size_t i = 0; i < line.size(); i++) {
        if (line[i] == '"' && i + 1 < line.size()) {
            s.push_back(line[i + 1]);
            i += 2; // skip char and closing quote
        }
    }
    Solution().reverseString(s);
    cout << JsonOutput::charVector(s) << endl;
    return 0;
}
