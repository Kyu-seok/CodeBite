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
    vector<int> rocks;
    if (!inner.empty()) {
        stringstream ss(inner);
        string token;
        while (getline(ss, token, ',')) {
            rocks.push_back(stoi(token));
        }
    }
    vector<int> result = Solution().resolveLaneCrashes(rocks);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
