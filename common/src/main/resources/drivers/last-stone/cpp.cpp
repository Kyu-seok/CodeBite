#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <queue>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string inner = line.substr(1, line.size() - 2);
    vector<int> stones;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) stones.push_back(stoi(token));
    int result = Solution().lastStoneWeight(stones);
    cout << result << endl;
    return 0;
}
