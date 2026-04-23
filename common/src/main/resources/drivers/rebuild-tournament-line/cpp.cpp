#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
    vector<vector<int>> people;
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
            people.push_back(row);
            i = j + 1;
        } else {
            i++;
        }
    }
    vector<vector<int>> result = Solution().orderTicketHolders(people);
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
