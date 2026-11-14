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
    string inner = line.substr(1, line.size() - 2);
    vector<int> scans;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        scans.push_back(stoi(token));
    }
    Solution().moveVoidsToEnd(scans);
    cout << JsonOutput::intVector(scans) << endl;
    return 0;
}
