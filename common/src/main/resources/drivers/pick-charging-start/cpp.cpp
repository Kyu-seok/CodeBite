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
    string energyLine, drainLine;
    getline(cin, energyLine);
    getline(cin, drainLine);
    vector<int> energy = parseArr(energyLine);
    vector<int> drain = parseArr(drainLine);
    int result = Solution().pickStartStop(energy, drain);
    cout << result << endl;
    return 0;
}
