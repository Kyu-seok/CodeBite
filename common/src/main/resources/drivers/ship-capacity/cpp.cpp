#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string weightsLine;
    getline(cin, weightsLine);
    string inner = weightsLine.substr(1, weightsLine.size() - 2);
    vector<int> weights;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        weights.push_back(stoi(token));
    }
    int days;
    cin >> days;
    int result = Solution().shipWithinDays(weights, days);
    cout << result << endl;
    return 0;
}
