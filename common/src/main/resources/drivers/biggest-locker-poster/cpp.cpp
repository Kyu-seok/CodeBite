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
    vector<int> lockers;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        lockers.push_back(stoi(token));
    }
    int result = Solution().largestPosterArea(lockers);
    cout << result << endl;
    return 0;
}
