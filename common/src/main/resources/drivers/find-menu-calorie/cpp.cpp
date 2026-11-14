#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string menuLine;
    getline(cin, menuLine);
    int target;
    cin >> target;

    // Parse 2D array: [[1,4,7,11,15],[2,5,8,12,19],...]
    vector<vector<int>> menu;
    size_t i = 1; // skip leading '['
    while (i < menuLine.size()) {
        if (menuLine[i] == '[') {
            size_t j = menuLine.find(']', i);
            string sub = menuLine.substr(i + 1, j - i - 1);
            vector<int> row;
            stringstream ss(sub);
            string token;
            while (getline(ss, token, ',')) {
                row.push_back(stoi(token));
            }
            menu.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    bool result = Solution().findCalorie(menu, target);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
