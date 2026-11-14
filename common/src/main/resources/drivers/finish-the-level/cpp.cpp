#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string inner = line.substr(1, line.size() - 2);
    vector<int> jumps;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        jumps.push_back(stoi(token));
    }
    bool result = Solution().canFinishLevel(jumps);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
