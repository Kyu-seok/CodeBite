#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

vector<int> parseArr(const string& line) {
    string inner = line.substr(1, line.size() - 2);
    vector<int> result;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) result.push_back(stoi(token));
    return result;
}

int main() {
    string gasLine, costLine;
    getline(cin, gasLine);
    getline(cin, costLine);
    vector<int> gas = parseArr(gasLine);
    vector<int> cost = parseArr(costLine);
    int result = Solution().pickStartStation(gas, cost);
    cout << result << endl;
    return 0;
}
