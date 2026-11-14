#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string scoresLine;
    getline(cin, scoresLine);
    string inner = scoresLine.substr(1, scoresLine.size() - 2);
    vector<int> scores;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        scores.push_back(stoi(token));
    }
    string kLine;
    getline(cin, kLine);
    int k = stoi(kLine);
    int result = Solution().kthHighestScore(scores, k);
    cout << result << endl;
    return 0;
}
