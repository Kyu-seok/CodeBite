#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

{USER_CODE}

vector<int> parseArray(const string& line) {
    string inner = line.substr(1, line.size() - 2);
    vector<int> result;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        result.push_back(stoi(token));
    }
    return result;
}

int main() {
    int target;
    cin >> target;
    cin.ignore();
    string posLine, spdLine;
    getline(cin, posLine);
    getline(cin, spdLine);
    vector<int> position = parseArray(posLine);
    vector<int> speed = parseArray(spdLine);
    int result = Solution().groupTrainPacks(target, position, speed);
    cout << result << endl;
    return 0;
}
