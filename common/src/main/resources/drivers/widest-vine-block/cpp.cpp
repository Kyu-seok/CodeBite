#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <stack>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string inner = line.substr(1, line.size() - 2);
    vector<int> heights;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        heights.push_back(stoi(token));
    }
    int result = Solution().widestVineBlock(heights);
    cout << result << endl;
    return 0;
}
