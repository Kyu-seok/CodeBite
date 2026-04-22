#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string pilesLine;
    getline(cin, pilesLine);
    string inner = pilesLine.substr(1, pilesLine.size() - 2);
    vector<int> piles;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        piles.push_back(stoi(token));
    }
    int h;
    cin >> h;
    int result = Solution().slowestConveyorSpeed(piles, h);
    cout << result << endl;
    return 0;
}
