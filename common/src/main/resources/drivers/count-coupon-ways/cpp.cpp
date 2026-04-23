#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    int amount;
    cin >> amount;
    cin.ignore();
    string coinsLine;
    getline(cin, coinsLine);
    string inner = coinsLine.substr(1, coinsLine.size() - 2);
    vector<int> coins;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        coins.push_back(stoi(token));
    }
    int result = Solution().countCouponCombos(amount, coins);
    cout << result << endl;
    return 0;
}
