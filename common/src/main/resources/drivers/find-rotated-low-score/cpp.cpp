#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string scoresLine;
    getline(cin, scoresLine);
    // Parse [3,4,5,1,2] -> vector<int>
    string inner = scoresLine.substr(1, scoresLine.size() - 2);
    vector<int> scores;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        scores.push_back(stoi(token));
    }
    int result = Solution().findLowestScore(scores);
    cout << result << endl;
    return 0;
}
