#include <iostream>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string kStr;
    getline(cin, kStr);
    int k = stoi(kStr);
    ListNode* head = listFromArray(line);
    head = Solution().flipSorterSegments(head, k);
    cout << listToJsonArray(head) << endl;
    return 0;
}
