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
    // Parse [[1,2,3],[4,5,6],[7,8,9]]
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
    Solution().clearDefectRows(matrix);
    cout << JsonOutput::intVector2D(matrix) << endl;
    return 0;
}
