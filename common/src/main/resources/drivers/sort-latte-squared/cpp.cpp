#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string driftsLine;
    getline(cin, driftsLine);
    string inner = driftsLine.substr(1, driftsLine.size() - 2);
    vector<int> drifts;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        drifts.push_back(stoi(token));
    }
    vector<int> result = Solution().sortedSquaredDrifts(drifts);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
