#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[9,9,4],[6,6,8],[2,1,1]]
    vector<vector<int>> matrix;
    int i = 0;
    while (i < (int)line.size()) {
        if (line[i] == '[' && i > 0) {
            int j = line.find(']', i);
            string sub = line.substr(i + 1, j - i - 1);
            vector<int> row;
            stringstream ss(sub);
            string token;
            while (getline(ss, token, ',')) {
                row.push_back(stoi(token));
            }
            matrix.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    cout << Solution().longestVineAscent(matrix) << endl;
    return 0;
}
