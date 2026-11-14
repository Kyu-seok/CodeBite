#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string votesLine;
    getline(cin, votesLine);
    string inner = votesLine.substr(1, votesLine.size() - 2);
    vector<int> votes;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        votes.push_back(stoi(token));
    }
    int result = Solution().majorityVote(votes);
    cout << result << endl;
    return 0;
}
