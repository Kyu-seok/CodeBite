#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string volumesLine;
    getline(cin, volumesLine);
    string inner = volumesLine.substr(1, volumesLine.size() - 2);
    vector<int> volumes;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        volumes.push_back(stoi(token));
    }
    int days;
    cin >> days;
    int result = Solution().minDailyCapacity(volumes, days);
    cout << result << endl;
    return 0;
}
