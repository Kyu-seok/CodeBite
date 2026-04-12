#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    int numCourses;
    string line;
    getline(cin, line);
    numCourses = stoi(line);
    getline(cin, line);
    // Parse 2D int array [[1,0],[2,1]]
    vector<vector<int>> prerequisites;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty() && inner.find('[') != string::npos) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '[') {
                int j = inner.find(']', i);
                string pairStr = inner.substr(i + 1, j - i - 1);
                vector<int> pair;
                stringstream ss(pairStr);
                string token;
                while (getline(ss, token, ',')) {
                    pair.push_back(stoi(token));
                }
                prerequisites.push_back(pair);
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    bool result = Solution().canFinish(numCourses, prerequisites);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
