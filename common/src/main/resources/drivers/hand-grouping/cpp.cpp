#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string handLine;
    getline(cin, handLine);
    string inner = handLine.substr(1, handLine.size() - 2);
    vector<int> hand;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        hand.push_back(stoi(token));
    }
    int groupSize;
    cin >> groupSize;
    bool result = Solution().isNStraightHand(hand, groupSize);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
