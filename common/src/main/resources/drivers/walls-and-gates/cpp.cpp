#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[2147483647,-1,0,2147483647],[...]]
    vector<vector<int>> rooms;
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
            rooms.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    Solution().wallsAndGates(rooms);
    cout << JsonOutput::intVector2D(rooms) << endl;
    return 0;
}
