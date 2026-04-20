#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);

    vector<ListNode*> lists;
    if (line != "[]") {
        // Remove outer brackets
        string inner = line.substr(1, line.size() - 2);
        int depth = 0;
        int start = 0;
        for (int i = 0; i < (int)inner.size(); i++) {
            if (inner[i] == '[') depth++;
            else if (inner[i] == ']') depth--;
            else if (inner[i] == ',' && depth == 0) {
                lists.push_back(listFromArray(inner.substr(start, i - start)));
                start = i + 1;
            }
        }
        lists.push_back(listFromArray(inner.substr(start)));
    }

    ListNode* result = Solution().mergeKLists(lists);
    cout << listToJsonArray(result) << endl;
    return 0;
}
