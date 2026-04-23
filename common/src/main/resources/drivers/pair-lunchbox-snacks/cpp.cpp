#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
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
    int capacity;
    cin >> capacity;
    int result = Solution().pairCrates(weights, capacity);
    cout << result << endl;
    return 0;
}
