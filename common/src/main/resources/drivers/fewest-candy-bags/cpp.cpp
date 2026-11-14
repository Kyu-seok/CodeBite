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
    vector<int> bagSizes;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        bagSizes.push_back(stoi(token));
    }
    int quota;
    cin >> quota;
    cout << Solution().fewestBags(bagSizes, quota) << endl;
    return 0;
}
