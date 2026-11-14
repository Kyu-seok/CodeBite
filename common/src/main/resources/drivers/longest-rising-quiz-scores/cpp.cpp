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
    vector<int> scores;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        scores.push_back(stoi(token));
    }
    cout << Solution().longestRisingScores(scores) << endl;
    return 0;
}
