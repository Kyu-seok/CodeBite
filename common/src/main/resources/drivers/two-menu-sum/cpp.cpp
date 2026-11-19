#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string menuPriceLine;
    getline(cin, menuPriceLine);
    string inner = menuPriceLine.substr(1, menuPriceLine.size() - 2);
    vector<int> menuPrice;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        menuPrice.push_back(stoi(token));
    }
    int budget;
    cin >> budget;
    vector<int> result = Solution().findMenuPair(menuPrice, budget);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
