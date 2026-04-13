#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <stack>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string numsLine;
    getline(cin, numsLine);
    string inner = numsLine.substr(1, numsLine.size() - 2);
    vector<int> temperatures;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        temperatures.push_back(stoi(token));
    }
    vector<int> result = Solution().dailyTemperatures(temperatures);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
