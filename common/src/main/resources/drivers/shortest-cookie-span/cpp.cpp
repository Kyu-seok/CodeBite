#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <climits>
using namespace std;

{USER_CODE}

int main() {
    string traysLine;
    getline(cin, traysLine);
    string inner = traysLine.substr(1, traysLine.size() - 2);
    vector<int> trays;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        trays.push_back(stoi(token));
    }
    int target;
    cin >> target;
    int result = Solution().shortestCookieSpan(trays, target);
    cout << result << endl;
    return 0;
}
