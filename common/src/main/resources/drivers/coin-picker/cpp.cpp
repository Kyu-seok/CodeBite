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
    vector<int> coins;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        coins.push_back(stoi(token));
    }
    int amount;
    cin >> amount;
    cout << Solution().coinChange(coins, amount) << endl;
    return 0;
}
