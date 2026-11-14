#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <stack>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string readingsLine;
    getline(cin, readingsLine);
    string inner = readingsLine.substr(1, readingsLine.size() - 2);
    vector<int> readings;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        readings.push_back(stoi(token));
    }
    vector<int> result = Solution().daysUntilWarmer(readings);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
