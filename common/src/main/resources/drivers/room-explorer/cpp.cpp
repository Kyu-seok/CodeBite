#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse 2D int array [[1],[2],[3],[]]
    vector<vector<int>> rooms;
    string inner = line.substr(1, line.size() - 2);
    int i = 0;
    while (i < (int)inner.size()) {
        if (inner[i] == '[') {
            int j = inner.find(']', i);
            string content = inner.substr(i + 1, j - i - 1);
            vector<int> room;
            if (!content.empty()) {
                stringstream ss(content);
                string token;
                while (getline(ss, token, ',')) {
                    room.push_back(stoi(token));
                }
            }
            rooms.push_back(room);
            i = j + 1;
        } else {
            i++;
        }
    }
    bool result = Solution().canVisitAllRooms(rooms);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
