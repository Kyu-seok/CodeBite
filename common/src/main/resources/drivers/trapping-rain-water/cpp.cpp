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
    vector<int> height;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        height.push_back(stoi(token));
    }
    int result = Solution().trap(height);
    cout << result << endl;
    return 0;
}
