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
    vector<int> lineup;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        lineup.push_back(stoi(token));
    }
    Solution().nextLineup(lineup);
    cout << JsonOutput::intVector(lineup) << endl;
    return 0;
}
