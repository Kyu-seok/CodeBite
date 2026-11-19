#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse JSON array [-1,0,0,1,1]
    string inner = line.substr(1, line.size() - 2);
    vector<int> parent;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        parent.push_back(stoi(token));
    }
    int result = Solution().countTaskOrders(parent);
    cout << result << endl;
    return 0;
}
