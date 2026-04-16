#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string matrixLine;
    getline(cin, matrixLine);
    int target;
    cin >> target;

    // Parse 2D array: [[1,4,7,11,15],[2,5,8,12,19],...]
    vector<vector<int>> matrix;
    size_t i = 1; // skip leading '['
    while (i < matrixLine.size()) {
        if (matrixLine[i] == '[') {
            size_t j = matrixLine.find(']', i);
            string sub = matrixLine.substr(i + 1, j - i - 1);
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
    bool result = Solution().searchMatrix(matrix, target);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
