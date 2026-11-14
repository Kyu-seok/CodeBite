#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string balloonsLine;
    getline(cin, balloonsLine);
    string inner = balloonsLine.substr(1, balloonsLine.size() - 2);
    vector<int> balloons;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        balloons.push_back(stoi(token));
    }
    int result = Solution().maxPopPoints(balloons);
    cout << result << endl;
    return 0;
}
