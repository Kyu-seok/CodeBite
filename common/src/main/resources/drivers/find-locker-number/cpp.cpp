#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string lockersLine;
    getline(cin, lockersLine);
    // Parse [x,y,z] -> vector<int>
    string inner = lockersLine.substr(1, lockersLine.size() - 2);
    vector<int> lockers;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        lockers.push_back(stoi(token));
    }
    int target;
    cin >> target;
    int result = Solution().findLocker(lockers, target);
    cout << result << endl;
    return 0;
}
